# frozen_string_literal: true

class WebhookService
  include FaradayService

  def initialize(webhook_url)
    fail ArgumentError.new('WebhookService missing webhook url') if webhook_url.blank?

    @webhook_url = webhook_url
    @connection = build_connection
  end

  def create_lead(lead_data)
    response = @connection.post(@webhook_url) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = lead_data.to_json
    end

    handle_response(response)
  end
end
