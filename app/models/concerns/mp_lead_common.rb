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
