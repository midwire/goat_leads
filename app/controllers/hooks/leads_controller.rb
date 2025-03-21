# frozen_string_literal: true

# This webhook is for incoming leads of all types
class Hooks::LeadsController < WebhookController
  # POST /hooks/leads
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
