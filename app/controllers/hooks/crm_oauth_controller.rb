# frozen_string_literal: true

class Hooks::CrmOauthController < WebhookController
  # GET /hooks/crm_initiate
  def initiate
    service = GhlOauthService.new(
      Rails.application.credentials.ghl[:client_id],
      Rails.application.credentials.ghl[:client_secret]
    )

    redirect_to(service.redirect_url, allow_other_host: true)
  end

  # GET /hooks/crm_oauth?code=:code
  def oauth
    response = service.post_oauth_request(code_param, hooks_crm_oauth_url)
    faraday_response = service.faraday_response
    if faraday_response[:success] == false
      error = faraday_response[:error]
      detail = faraday_response[:dedtails]
      Rails.logger.error(">>> GHL integration error: #{error}, #{detail}")
      redirect_to(root_url, alert: error)
      return
    end

    # We got a successful GHL OAuth response
    integrate_ghl(response)
  end

  private

  def code_param
    params.require(:code)
  end

  def post_oauth_request
    conn = build_connection(form_url_encode: true)
    conn.post(TOKEN_URL) do |req|
      req.headers['Accept'] = 'application/json'
      req.headers['Content-Type'] = 'x-www-form-urlencoded'
      req.body = payload
    end
  end

  def payload
    @payload ||= {
      client_id: Rails.application.credentials.ghl[:client_id],
      client_secret: Rails.application.credentials.ghl[:client_secret],
      grant_type: 'authorization_code',
      code: code_param,
      user_type: 'Location',
      redirect_uri: hooks_crm_oauth_url
    }
  end

  def integrate_ghl(response)
    # Wire-up GHL integration
    if current_user = Current.user
      update_user(current_user, response)
      redirect_to(lead_orders_path, alert: 'CRM Integration is now complete. Welcome on board.')
    else
      prep_session_vars(response)
      redirect_to(new_user_session_url, alert: 'Login to complete CRM Integration')
    end
  end

  def update_user(user, response)
    user.update(
      ghl_company_id: response['companyId'],
      ghl_location_id: response['locationId'] || response['userId'],
      ghl_access_token: response['access_token'],
      ghl_refresh_token: response['refresh_token'],
      ghl_refresh_date: Date.current
    )
  end

  def prep_session_vars(response)
    session[:ghl] = {
      company_id: response['companyId'],
      location_id: response['locationId'],
      access_token: response['access_token'],
      refresh_token: response['refresh_token']
    }
  end
end
