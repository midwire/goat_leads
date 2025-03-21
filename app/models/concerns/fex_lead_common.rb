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
  # rubocop:enable Metrics/MethodLength
end
