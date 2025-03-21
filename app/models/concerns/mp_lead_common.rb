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
  # rubocop:enable Metrics/MethodLength
end
