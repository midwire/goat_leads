# frozen_string_literal: true

class LeadDistributor
  class << self
    def distrbute_lead(lead)
      send_to_ringy(lead) if lead.lead_order.ringy_enabled?
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
        Rails.logger.error("Failed to send lead #{lead.id} to Ringy: #{response[:error]}")
      end

      response
    end
  end
end
