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
  # rubocop:enable Metrics/MethodLength
end
