# frozen_string_literal: true

# This webhook is for incoming leads of all types
class Hooks::LeadsController < WebhookController
  ALLOWED_PARAMS = {
    address: 'Address string',
    adset_id: 'Adset ID - string',
    amt_requested: 'Amount requested string',
    beneficiary: 'Beneficiary type - example: Spouse - string',
    beneficiary_name: 'Name of beneficiaries string',
    branch_of_service: 'Branch of military service - string',
    campaign_id: 'Campaign ID - string',
    city: 'City - string',
    contact_time_of_day: 'Best time to contact you string',
    current_retirement_plan: 'Current retirement plan - string',
    desired_monthly_contrib: 'Monthly contribution - string',
    desired_retirement_age: 'Desired retirement age - string',
    dob: 'Date of Birth string - example: "12-01-1943" - REQUIRED',
    email: 'Email string - REQUIRED',
    employment_status: 'Employment status - string',
    external_lead_id: 'ELID - string',
    favorite_hobby: 'Favorite hobby - string',
    fbc_id: 'Facebook ID string',
    fbclid: 'Facebook Client ID string',
    first_name: 'First Name string - REQUIRED',
    full_name: 'Full Name string',
    gender: 'Gender string',
    google_click_id: 'Google click ID - string',
    h_ad_id: 'Ad ID string',
    has_life_insurance: 'Has life insurance - string',
    health_history: 'Any history of cancer, heart attack, etc - string',
    ip_address: 'IP Address string',
    is_dropoff: 'Dropoff string',
    iul_goal: 'IUL goal - string',
    last_name: 'Last Name string - REQUIRED',
    lead_class: 'Lead Class Name string - "VeteranLeadPremium", etc. - REQUIRED',
    lead_form_name: 'Lead form name - string',
    lead_order_id: 'Lead order ID - string',
    lead_program: 'Lead program - string',
    location: 'Location - string',
    marital_status: 'Marital Status string',
    military_status: 'Military Status string',
    monthly_contribution: 'Monthly contribution - string',
    mortgage_balance: 'Mortgage balance - string',
    mortgage_payment: 'Mortgage payment - string',
    needed_coverage: 'How much coverage do you need string',
    otp_code: 'OTP code - string',
    outside_company: 'Outside company - string',
    page_url: 'Page URL - string',
    parent_url: 'Parent URL string',
    phone: 'Phone string - at least 10 digits - REQUIRED',
    platform: 'Platform - string',
    ref_id: 'Referal ID',
    retirement_age: 'Retirement age - string',
    start: 'Unknown string',
    state: 'Lead State string - REQUIRED',
    trusted_form_url: 'TFU - string',
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
    video_type: 'Video Type string - *Other or Dom',
    zip: 'Zipcode - string'
  }.freeze

  # POST /hooks/leads
  def create
    parser = LeadParser.new(lead_params)
    lead = parser.model_instance
    if lead.save
      AssignLeadsJob.perform_async
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
