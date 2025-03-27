# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'

module FaradayService
  extend ActiveSupport::Concern

  private

  def build_connection(base_url = nil)
    Faraday.new(url: base_url) do |conn|
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
      { success: false, error: unauthorized_error_message }
    when 400..499
      { success: false, error: ">>> Client error: #{response.status}", details: response.body }
    when 500..599
      { success: false, error: ">>> Server error: #{response.status}" }
    else
      { success: false, error: ">>> Unexpected response: #{response.status}" }
    end
  end

  def unauthorized_error_message
    '>>> Unauthorized: Invalid credentials'
  end
end
