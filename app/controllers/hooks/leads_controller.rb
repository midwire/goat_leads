# frozen_string_literal: true

class Hooks::LeadsController < WebhookController
  # POST /leads/leads
  def create
    parser = LeadParser.new(lead_params)
    lead = parser.model_instance
    if lead.save
      head :created
    else
      head :unprocessable_content
    end
  end
end
