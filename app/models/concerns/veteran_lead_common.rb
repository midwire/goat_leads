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

  # rubocop:disable Metrics/Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
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
        { 'key' => 'best_time_to_call', 'value' => lead.contact_time_of_day },
        { 'key' => 'otp_field', 'value' => lead.otp_code },
        { 'key' => 'trusted_certificate', 'value' => lead.trusted_form_url },
        { 'key' => 'ip_address_of_lead', 'value' => lead.ip_address }
      ],
      'firstName' => lead.first_name,
      'lastName' => lead.last_name,
      'email' => lead.email,
      'phone' => lead.phone,
      'locationId' => user.ghl_location_id,
      'tags' => tags,
      'source' => Settings.whitelabel.site_domain,
      'country' => 'US'
    }
  end
  # rubocop:enable Metrics/Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def sms_message(lead)
    lead = lead.decorate
    [
      'New Veteran Lead! Sell It!',
      "Name: #{lead.first_name} #{lead.last_name}",
      "Phone: #{lead.phone}",
      "Email: #{lead.email}",
      "Coverage Requested: #{lead.needed_coverage}",
      "State: #{lead.state}",
      "Lead Type: #{lead.type}",
      '',
      'Check Your Email For More Details!'
    ].join("\n")
  end
end
