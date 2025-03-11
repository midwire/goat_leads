# frozen_string_literal: true

class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access

  ALLOWED_PARAMS = {
    ref_id: 'Referal ID',
    lead_quality: 'Lead Quality string - Standard or *Premium',
    video_type: 'Video Type string - *Other or Dom',
    parent_url: 'Parent URL string',
    ip_address: 'IP Address string',
    user_agent: 'User Agent string',
    is_dropoff: 'Dropoff string',
    utm_source: 'UTM Source string',
    utm_medium: 'UTM Medium string',
    utm_campaign: 'UTM Campaign string',
    utm_content: 'UTM Content string',
    utm_adset: 'UTM Adset string',
    utm_site_source: 'UTM Site Source string',
    utm_owner: 'UTM Owner string',
    fbc_id: 'Facebook ID string',
    h_ad_id: 'Ad ID string',
    utm_id: 'UTM ID string',
    utm_term: 'UTM Term string',
    fbclid: 'Facebook Client ID string',
    start: 'Unknown string',
    state: 'Lead State string',
    dob: 'Date of Birth string - example: "12-01-1943"',
    full_name: 'Full Name string',
    email: 'Email string',
    phone: 'Phone string - at least 10 digits',
    'step_2_-_military_status' => 'Military Status string',
    'step_3_-_marital_status' => 'Marital Status string',
    'step_4_-_how_much_coverage' => 'Needed Coverage string',
    'step_6_-_best_time_to_contact' => 'Contact Time string'
  }.freeze

  private

  def lead_params
    params.require(:form).permit(ALLOWED_PARAMS.keys)
  end
end
