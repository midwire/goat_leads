# frozen_string_literal: true

class Leads::VeteranLeadsController < WebhookController
  # POST /leads/veteran_lead
  def create
    parser = LeadParser.new(lead_params, :veteran_lead)
    lead = parser.model_instance
    if lead.save
      head :created
    else
      head :unprocessable_content
    end
  end
end
