# frozen_string_literal: true

module VeteranLeadCommon
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
      'State' => :state,
      'DOB' => :dob,
      'Marital Status' => :marital_status,
      'Military Status' => :military_status,
      'How Much Coverage Do You Need?' => :needed_coverage,
      'Best Time of Day to Contact You?' => :contact_time_of_day,
      'RR State' => :rr_state,
      'Ad' => :ad,
      'Adset' => :adset_id,
      'Owner' => :owner,
      'Platform' => :platform,
      'Military Branch' => :branch_of_service,
      'Age' => :current_age
    }
  end
end
