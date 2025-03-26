# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'

class RingyService
  def initialize(sid, auth_token)
    @sid = sid
    @auth_token = auth_token
    @connection = build_connection
  end

  def create_lead(lead_data)
    lead_data.merge!({'sid' => @sid, 'authToken' => @auth_token})
    response = @connection.post('/api/public/leads/new-lead') do |req|
      # req.headers['Authorization'] = "Bearer #{@auth_token}"
      # req.headers['X-Ringy-SID'] = @sid
      req.headers['Content-Type'] = 'application/json'
      req.body = lead_data.to_json
    end

    handle_response(response)
  end

  private

  def build_connection
    Faraday.new(url: 'https://app.ringy.com') do |conn|
      # Automatically parse JSON responses
      conn.response :json, content_type: /\bjson$/

      # Retry on transient failures (e.g., 429, 503)
      conn.request :retry, max: 3, interval: 1, backoff_factor: 2

      # Use the default adapter (Net::HTTP), or switch to Typhoeus for better performance
      conn.adapter Faraday.default_adapter
    end
  end

  def handle_response(response)
    case response.status
    when 200..201
      { success: true, data: response.body }
    when 401
      { success: false, error: '>>> Unauthorized: Invalid SID or auth token' }
    when 400..499
      { success: false, error: ">>> Client error: #{response.status}", details: response.body }
    when 500..599
      { success: false, error: ">>> Server error: #{response.status}" }
    else
      { success: false, error: ">>> Unexpected response: #{response.status}" }
    end
  end
end
