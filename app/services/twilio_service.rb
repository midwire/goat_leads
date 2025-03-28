# frozen_string_literal: true

require 'twilio-ruby'

class TwilioService
  def initialize
    @client = Twilio::REST::Client.new(
      Rails.application.credentials.twilio[:account_sid],
      Rails.application.credentials.twilio[:auth_token]
    )
    @from_number = Rails.application.credentials.twilio[:phone_number]
  end

  # Send a text message to a user
  # @param to [String] The recipient's phone number (e.g., "+19876543210")
  # @param body [String] The message content
  # @return [Hash] Success status and message SID or error details
  def send_sms(to, body)
    message = @client.messages.create(
      from: @from_number,
      to: to,
      body: body
    )

    { success: true, message_sid: message.sid }
  rescue Twilio::REST::RestError => e
    Rails.logger.error "Twilio SMS failed: #{e.message}"
    { success: false, error: e.message }
  end

  # Optional: Check if a phone number is valid (basic format check)
  def valid_phone_number?(number)
    number.match?(/^\+\d{10,15}$/) # Matches + followed by 10-15 digits
  end
end
