# frozen_string_literal: true

# This webhook is for incoming leads of all types
class Hooks::LeadsController < WebhookController
  ALLOWED_PARAMS = {
    'step_2_-_military_status' => 'Military Status string',
    'step_3_-_marital_status' => 'Marital Status string',
    'step_4_-_how_much_coverage' => 'Needed Coverage string',
    'step_6_-_best_time_to_contact' => 'Contact Time string',
    dob: 'Date of Birth string - example: "12-01-1943" - REQUIRED',
    email: 'Email string - REQUIRED',
    fbc_id: 'Facebook ID string',
    fbclid: 'Facebook Client ID string',
    first_name: 'First Name string - REQUIRED',
    full_name: 'Full Name string',
    h_ad_id: 'Ad ID string',
    ip_address: 'IP Address string',
    is_dropoff: 'Dropoff string',
    last_name: 'Last Name string - REQUIRED',
    lead_class: 'Lead Class Name string - "VeteranLeadPremium", etc. - REQUIRED',
    parent_url: 'Parent URL string',
    phone: 'Phone string - at least 10 digits - REQUIRED',
    ref_id: 'Referal ID',
    start: 'Unknown string',
    state: 'Lead State string - REQUIRED',
    user_agent: 'User Agent string',
    utm_adset: 'UTM Adset string',
    utm_campaign: 'UTM Campaign string',
    utm_content: 'UTM Content string',
    utm_id: 'UTM ID string',
    utm_medium: 'UTM Medium string',
    utm_owner: 'UTM Owner string',
    utm_site_source: 'UTM Site Source string',
    utm_source: 'UTM Source string',
    utm_term: 'UTM Term string',
    video_type: 'Video Type string - *Other or Dom'
  }.freeze

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

  private

  def lead_params
    params.require(:form).permit(ALLOWED_PARAMS.keys)
  end
end
