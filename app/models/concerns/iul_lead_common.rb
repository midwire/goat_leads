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
end
