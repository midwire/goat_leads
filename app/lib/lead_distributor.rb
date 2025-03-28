# frozen_string_literal: true

class LeadDistributor
  class << self
    def distribute_lead(lead)
      send_to_ringy(lead) if lead.lead_order.ringy_enabled?
      send_to_webhook(lead) if lead.lead_order.webhook_enabled?
      send_to_sms(lead) if lead.lead_order.sms_enabled?
    end

    private

    def send_to_ringy(lead)
      lead_order = lead.lead_order
      ringy_service = RingyService.new(lead_order.ringy_sid, lead_order.ringy_auth_token)
      lead_data = lead.to_ringy_format
      response = ringy_service.create_lead(lead_data)

      if response[:success]
        Rails.logger.info("Lead #{lead.id} successfully sent to Ringy: #{response[:data]}")
      else
        msg = "Failed to send lead #{lead.id} to Ringy: #{response[:error]}"
        Rails.logger.error(msg)
        SlackPipe.send_msg(msg)
      end

      response
    end

    def send_to_webhook(lead)
      lead_order = lead.lead_order
      webhook_service = WebhookService.new(lead_order.webhook_url)
      lead_data = lead.to_webhook_format
      response = webhook_service.create_lead(lead_data)

      if response[:success]
        Rails.logger.info("Lead #{lead.id} successfully sent to Webhook: #{response[:data]}")
      else
        msg = "Failed to send lead #{lead.id} to Webhook: #{response[:error]}"
        Rails.logger.error(msg)
        SlackPipe.send_msg(msg)
      end

      response
    end

    def send_to_sms(lead)
      message = lead.sms_message
      service = TwilioService.new
      response = service.send_sms(lead.lead_order.agent_phone, message)

      if response[:success]
        Rails.logger.info("Lead #{lead.id} successfully sent to SMS: #{response[:message_sid]} ")
      else
        msg = "TwilioService failed to send SMS for lead: #{lead.id}, message: #{response[:error]}"
        Rails.logger.error(msg)
        SlackPipe.send_msg(msg)
      end
    end
  end
end
