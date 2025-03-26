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

  def to_ringy_format
    lead = decorate
    {
      phone_number: lead.phone,
      first_name: lead.first_name,
      last_name: lead.last_name,
      email: lead.email,
      state: lead.state,
      birthday: lead.dob&.to_s,
      marital_status: lead.marital_status,
      military_status: lead.military_status,
      how_much_coverage_do_you_need: lead.needed_coverage,
      best_time_of_day_to_contact: lead.contact_time_of_day,
      platform: lead.platform,
      age: lead.age,
      military_branch: lead.branch_of_service,
      lead_source: Settings.whitelabel.site_title
    }
  end
end
