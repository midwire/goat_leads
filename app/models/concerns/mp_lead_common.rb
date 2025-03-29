# frozen_string_literal: true

module MpLeadCommon
  extend ActiveSupport::Concern

  # Spreadsheet Data
  # Column-heading => Decorated lead method
  # rubocop:disable Metrics/MethodLength
  def spreadsheet_data
    {
      'Date/Time' => :created_at,
      'First Name' => :first_name,
      'Last Name' => :last_name,
      'Email' => :email,
      'Phone' => :phone,
      'Age' => :current_age,
      'History of Heart Attack Stroke Cancer' => :health_history,
      'Beneficiary' => :beneficiary,
      'Beneficiary Name' => :beneficiary_name,
      'Mortgage Balance' => :mortgage_balance,
      'Mortgage Payment' => :mortgage_payment,
      'State' => :state,
      'RR State' => :rr_state,
      'Owner' => :owner,
      'Trusted Form URL' => :trusted_form_url,
      'OTP Code' => :otp_code,
      'IP Address' => :ip_address,
      'Status' => :new_lead,
      'DOB' => :dob
    }
  end

  def to_ringy_format
    lead = decorate
    {
      phone_number: lead.phone,
      first_name: lead.first_name,
      last_name: lead.last_name,
      email: lead.email,
      street_address: lead.address,
      city: lead.city,
      state: lead.state,
      zip_code: lead.zip,
      birthday: lead.dob&.to_s,
      age: lead.age,
      health: lead.health_history,
      beneficiary: lead.beneficiary,
      beneficiary_name: lead.beneficiary_name,
      mortgage_balance: lead.mortgage_balance,
      mortgage_payment: lead.mortgage_payment,
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
        { 'key' => 'beneficiary_relationship', 'value' => lead.beneficiary },
        { 'key' => 'beneficiary', 'value' => lead.beneficiary_name },
        { 'key' => 'mortgage_balance_range', 'value' => lead.mortgage_balance },
        { 'key' => 'mortgage_payment_range', 'value' => lead.mortgage_payment },
        { 'key' => 'history_of_heart_attack_stroke_canceer', 'value' => lead.health_history },
        { 'key' => 'favorite_hobby_security_question', 'value' => lead.favorite_hobby },
        { 'key' => 'lead_source', 'value' => lead.platform },
        { 'key' => 'postal_code', 'value' => lead.zip },
        { 'key' => 'city', 'value' => lead.city },
        { 'key' => 'address1', 'value' => lead.address }
      ],
      'firstName' => lead.first_name,
      'lastName' => lead.last_name,
      'email' => lead.email,
      'phone' => lead.phone,
      'locationId' => user.ghl_location_id,
      'city' => lead.city,
      'state' => lead.state,
      'postalCode' => lead.zip,
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
      'New MP Lead',
      "Name: #{lead.first_name} #{lead.last_name}",
      "Phone: #{lead.phone}",
      "Email: #{lead.email}",
      "State: #{lead.state}",
      "DOB/Age: #{lead.dob}/#{lead.age}",
      '',
      'Check Your Email For More Details!'
    ].join("\n")
  end
end
