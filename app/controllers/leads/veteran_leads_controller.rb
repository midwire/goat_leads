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

  private

  # rubocop:disable Metrics/MethodLength
  def lead_params
    params.require(:form).permit(
      :ref_id,
      :parent_url,
      :ip_address,
      :user_agent,
      :is_dropoff,
      :utm_source,
      :utm_medium,
      :utm_campaign,
      :utm_content,
      :utm_adset,
      :utm_site_source,
      :utm_owner,
      :fbc_id,
      :h_ad_id,
      :utm_id,
      :utm_term,
      :fbclid,
      :start,
      :state,
      :dob,
      :full_name,
      :email,
      :phone,
      'step_2_-_military_status',
      'step_3_-_marital_status',
      'step_4_-_how_much_coverage',
      'step_6_-_best_time_to_contact'
    )
  end
  # rubocop:enable Metrics/MethodLength
end
