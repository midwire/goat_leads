# frozen_string_literal: true

class GhlService
  include FaradayService

  def initialize(auth_token, version = '2021-07-28')
    if auth_token.blank? || version.blank?
      fail ArgumentError.new('GhlService is missing auth_token or version')
    end

    @auth_token = auth_token
    @version = version
    @connection = build_connection(base_url: 'https://services.leadconnectorhq.com/opportunities')
  end

  def create_lead(lead_data)
    response = @connection.post('/contacts') do |req|
      req.headers['Authorization'] = "Bearer #{@auth_token}"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.headers['Version'] = @version
      req.body = lead_data.to_json
    end

    handle_response(response)
  end

  private

  def unauthorized_error_message
    '>>> Unauthorized: Invalid auth token'
  end
end
