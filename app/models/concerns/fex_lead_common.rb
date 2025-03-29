# frozen_string_literal: true

module FexLeadCommon
  extend ActiveSupport::Concern

  # Spreadsheet Data
  # Column-heading => Decorated lead method
  # rubocop:disable Metrics/MethodLength
  def spreadsheet_data
    {
      'Date/Time' => :created_at,
      'First Name' => :first_name,
      'Last Name' => :last_name,
      'DOB' => :dob,
      'Phone' => :phone,
      'Email' => :email,
      'Ad' => :ad,
      'Status' => :new_lead,
      'State' => :state,
      'RR State' => :rr_state,
      'Owner' => :owner,
      'Notes' => nil,
      'Date' => :lead_date,
      'Amt Requested' => :amt_requested,
      'Beneficiary' => :beneficiary,
      'Beneficiary Name' => :beneficiary_name,
      'Age' => :current_age,
      'Platform' => :platform,
      'Gender' => :gender,
      'History of Heart Attack Stroke Cancer' => :health_history,
      'Have Life Insurance' => :has_life_insurance,
      'Favorite Hobby' => :favorite_hobby
    }
  end

  def to_ringy_format
    lead = decorate
    {
      phone_number: lead.phone,
      first_name: lead.first_name,
      last_name: lead.last_name,
      email: lead.email,
      dob: lead.dob&.to_s,
      ad: lead.ad,
      status: 'New Lead',
      state: lead.state,
      notes: '',
      amt_requested: lead.amt_requested,
      beneficiary: lead.beneficiary,
      beneficiary_name: lead.beneficiary_name,
      age: lead.age,
      platform: lead.platform,
      lead_source: Settings.whitelabel.site_title
    }
  end

  # rubocop:disable Metrics/AbcSize
  def to_ghl_format
    user = lead_order.user
    lead = decorate
    tags = ['goatleads', lead.type]
    {
      'customFields' => [
        { 'key' => 'dob', 'value' => lead.date_of_birth },
        { 'key' => 'gender', 'value' => lead.gender },
        { 'key' => 'state_full_name', 'value' => lead.state },
        { 'key' => 'age', 'value' => lead.age },
        { 'key' => 'marital_status', 'value' => lead.marital_status },
        { 'key' => 'military_status', 'value' => lead.military_status },
        { 'key' => 'coverage_requested', 'value' => lead.needed_coverage },
        { 'key' => 'have_life_insurance', 'value' => lead.has_life_insurance },
        { 'key' => 'best_time_to_call', 'value' => lead.contact_time_of_day },
        { 'key' => 'otp_field', 'value' => lead.otp_code },
        { 'key' => 'trusted_certificate', 'value' => lead.trusted_form_url },
        { 'key' => 'ip_address_of_lead', 'value' => lead.ip_address },
        { 'key' => 'beneficiary_relationship', 'field_value' => lead.beneficiary },
        { 'key' => 'beneficiary', 'field_value' => lead.beneficiary_name },
        { 'key' => 'history_of_heart_attack_stroke_canceer', 'field_value' => lead.health_history },
        { 'key' => 'favorite_hobby_security_question', 'field_value' => lead.favorite_hobby },
        { 'key' => 'lead_source', 'field_value' => lead.platform },
        { 'key' => 'address1', 'value' => lead.address }
      ],
      'firstName' => lead.first_name,
      'lastName' => lead.last_name,
      'email' => lead.email,
      'phone' => lead.phone,
      'locationId' => user.ghl_location_id,
      'tags' => tags,
      'source' => Settings.whitelabel.site_domain,
      'country' => 'US'
    }
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def sms_message(lead)
    lead = lead.decorate
    [
      'New FEX Lead! Sell It!',
      "Name: #{lead.first_name} #{lead.last_name}",
      "Phone: #{lead.phone}",
      "Email: #{lead.email}",
      "State: #{lead.state}",
      "DOB/Age: #{lead.dob}/#{lead.age}",
      "Ad: #{lead.ad}",
      "Lead Type: #{lead.type}",
      "OTP Code: #{lead.otp_code}",
      '',
      'OTP Now ENABLED on all FEX Leads From Google/YouTube!',
      '',
      'Check Your Email For More Details!'
    ].join("\n")
  end
end
