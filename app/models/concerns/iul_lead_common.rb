# frozen_string_literal: true

module IulLeadCommon
  extend ActiveSupport::Concern

  # Spreadsheet Data
  # Column-heading => Decorated lead method
  def spreadsheet_data
    {
      'Date/Time' => :created_at,
      'First Name' => :first_name,
      'Last Name' => :last_name,
      'Phone' => :phone,
      'Email' => :email,
      'IUL Goal' => :iul_goal,
      'Employment Status' => :employment_status,
      'Desired Mo Contribution' => :desired_monthly_contrib,
      'Current Retirement Plan' => :current_retirement_plan,
      'DOB' => :dob,
      'Desired Retirement Age' => :desired_retirement_age,
      'State' => :state,
      'IP Address' => :ip_address,
      'OTP Code' => :otp_code,
      'Trusted Form URL' => :trusted_form_url,
      'Owner' => :owner,
      'Status' => :new_lead
    }
  end

  def to_ringy_format
    lead = decorate
    {
      phone_number: lead.phone,
      first_name: lead.first_name,
      last_name: lead.last_name,
      email: lead.email,
      iul_goal: lead.iul_goal,
      employment_status: lead.employment_status,
      desired_contribution: lead.desired_monthly_contrib,
      current_retirement_plan: lead.current_retirement_plan,
      birthday: lead.dob&.to_s,
      desired_retirement_age: lead.desired_retirement_age,
      state: lead.state,
      owner: lead.owner,
      lead_source: Settings.whitelabel.site_title
    }
  end

  # rubocop:disable Metrics/MethodLength
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
      'New IUL Lead! Sell It!',
      "Name: #{lead.first_name} #{lead.last_name}",
      "Phone: #{lead.phone}",
      "Email: #{lead.email}",
      "DOB/Age: #{lead.dob}/#{lead.age}",
      "Goal: #{lead.iul_goal}",
      "State: #{lead.state}",
      "Monthly Contribution: #{lead.monthly_contribution}",
      "Lead Type: #{lead.type}",
      '',
      'Check Your Email For More Details!'
    ].join("\n")
  end
end
