# frozen_string_literal: true

class RingyService
  include FaradayService

  def initialize(sid, auth_token)
    fail ArgumentError.new('RingyService missing sid or auth token') if sid.blank? || auth_token.blank?

    @sid = sid
    @auth_token = auth_token
    @connection = build_connection(base_url: 'https://app.ringy.com')
  end

  def create_lead(lead_data)
    lead_data.merge!({ 'sid' => @sid, 'authToken' => @auth_token })
    response = @connection.post('/api/public/leads/new-lead') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = lead_data.to_json
    end

    handle_response(response)
  end

  private

  def unauthorized_error_message
    '>>> Unauthorized: Invalid SID or auth token'
  end
end
