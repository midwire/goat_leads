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
end
