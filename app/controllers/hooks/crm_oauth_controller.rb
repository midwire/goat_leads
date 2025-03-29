# frozen_string_literal: true

class Hooks::CrmOauthController < WebhookController
  # This method redirects the browser to login to their GHL account for OAuth integration
  # GET /hooks/crm_initiate
  def initiate
    redirect_to(service.ghl_redirect_url, allow_other_host: true)
  end

  # After the user logs into their GHL account it should redirect here.
  # Then we ask GHL for a access and refresh tokens
  # GET /hooks/crm_oauth?code=:code
  def oauth
    response = service.post_oauth_request(code_param)
    faraday_response = service.faraday_response
    if faraday_response[:success] == false
      error = faraday_response[:error]
      detail = faraday_response[:details]
      Rails.logger.error(">>> GHL integration error: #{error}, #{detail}")
      redirect_to(root_url, alert: error)
      return
    end

    # We got a successful GHL OAuth response
    integrate_ghl(response.body)
  end

  private

  def code_param
    params.require(:code)
  end

  def service
    @service ||= GhlOauthService.new(
      Rails.application.credentials.ghl[:client_id],
      Rails.application.credentials.ghl[:client_secret],
      hooks_crm_oauth_url
    )
  end

  def integrate_ghl(ghl_data)
    if current_user = Current.user
      update_user(current_user, ghl_data)
      redirect_to(lead_orders_path, alert: 'CRM Integration is now complete. Welcome on board.')
    else
      prep_session_vars(ghl_data)
      redirect_to(new_user_session_url, alert: 'Login to complete CRM Integration')
    end
  end

  # Wire-up GHL integration
  def update_user(user, ghl_data)
    user.update!(
      ghl_company_id: ghl_data['companyId'],
      ghl_location_id: ghl_data['locationId'] || ghl_data['userId'],
      ghl_access_token: ghl_data['access_token'],
      ghl_refresh_token: ghl_data['refresh_token'],
      ghl_refresh_date: Date.current
    )
  end

  def prep_session_vars(ghl_data)
    session[:ghl] = {
      company_id: ghl_data['companyId'],
      location_id: ghl_data['locationId'],
      access_token: ghl_data['access_token'],
      refresh_token: ghl_data['refresh_token']
    }.to_json
  end
end
