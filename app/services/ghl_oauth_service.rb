# frozen_string_literal: true

class GhlOauthService
  include FaradayService

  MARKETPLACE_URL = 'https://marketplace.leadconnectorhq.com' unless defined?(MARKETPLACE_URL)
  TOKEN_URL = 'https://services.leadconnectorhq.com/oauth/token' unless defined?(TOKEN_URL)

  attr_reader :ghl_redirect_url, :faraday_response

  def initialize(client_id, client_secret, local_oauth_url)
    @client_id = client_id
    @client_secret = client_secret
    @local_oauth_url = local_oauth_url
    validate_args

    @ghl_redirect_url = "#{MARKETPLACE_URL}/oauth/chooselocation?#{options.to_query}"
    @connection = build_connection(form_url_encode: true)
  end

  def post_oauth_request(code_param)
    response = @connection.post(TOKEN_URL) do |req|
      req.headers['Accept'] = 'application/json'
      req.body = payload(code_param)
    end

    @faraday_response = handle_response(response)
    response
  end

  private

  def options
    {
      response_type: 'code',
      redirect_uri: @local_oauth_url,
      client_id: @client_id,
      scope: [
        'contacts.write',
        'locations/customFields.readonly',
        'locations/customFields.write',
        'locations/customValues.readonly',
        'locations/customValues.write'
      ].join(' ')
    }
  end

  def validate_args
    return unless @client_id.blank? || @client_secret.blank? || @local_oauth_url.blank?

    fail ArgumentError.new('GhlOauthService missing arguments')
  end

  def payload(code_param)
    {
      client_id: @client_id,
      client_secret: @client_secret,
      grant_type: 'authorization_code',
      code: code_param,
      user_type: 'Location',
      redirect_uri: @local_oauth_url
    }
  end
end
