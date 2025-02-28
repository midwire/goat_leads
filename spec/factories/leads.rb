# frozen_string_literal: true

FactoryBot.define do
  factory :lead do
    first_name { 'MyString' }
    last_name { 'MyString' }
  end
end

# == Schema Information
#
# Table name: leads
#
#  id                      :integer          not null, primary key
#  first_name              :string
#  last_name               :string
#  phone                   :string
#  email                   :string
#  state                   :string
#  dob                     :date
#  marital_status          :string
#  military_status         :string
#  needed_coverage         :string
#  contact_time_of_day     :string
#  rr_state                :string
#  ad                      :string
#  adset_id                :string
#  user_id                 :integer
#  platform                :string
#  campaign_id             :string
#  ringy_code              :string
#  lead_program            :string
#  ip_address              :string
#  location                :string
#  trusted_form_url        :string
#  verified_lead           :boolean
#  unique                  :boolean
#  policy_sold             :boolean
#  sold_on                 :date
#  agent_sold              :string
#  carrier_sold            :string
#  premium_sold            :string
#  lead_age                :integer
#  resold_on               :date
#  resold_owner            :string
#  external_lead_id        :string
#  video_type              :string
#  the_row                 :string
#  lead_date               :date
#  real_owner_name         :string
#  age                     :integer
#  veteran                 :boolean
#  branch_of_service       :string
#  lead_type               :string
#  outside_company         :string
#  google_click_id         :string
#  lead_form_at            :datetime
#  iul_goal                :string
#  employment_status       :string
#  monthly_contribution    :string
#  current_retirement_plan :string
#  retirement_age          :integer
#  lead_form_name          :string
#  page_url                :string
#  utm_source              :string
#  utm_medium              :string
#  utm_campaign            :string
#  utm_content             :string
#  utm_adset               :string
#  utm_site_source         :string
#  otp_code                :string
#  crm                     :string
#  crm_user                :string
#  crm_date                :string
#  crm_status              :string
#  ringy_status            :string
#  client_age              :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_leads_on_dob         (dob)
#  index_leads_on_email       (email)
#  index_leads_on_first_name  (first_name)
#  index_leads_on_last_name   (last_name)
#  index_leads_on_phone       (phone)
#  index_leads_on_state       (state)
#  index_leads_on_user_id     (user_id)
#
