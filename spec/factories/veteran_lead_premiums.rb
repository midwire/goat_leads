# frozen_string_literal: true

FactoryBot.define do
  factory :veteran_lead_premium do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::Base.numerify('1##########') }
    email { Faker::Internet.email }
    state { 'Washington' }
    dob { Faker::Date.between(from: '1930-01-01', to: 21.years.ago) }
    marital_status { Faker::Demographic.marital_status }
    military_status { Faker::Military.army_rank }
    needed_coverage { ['250,000+', '40,000 - 50,000', '20,000 - 30,000'].sample }
    contact_time_of_day { %w[Afternoon Evening Morning].sample }
    ad { Faker::Lorem.word }
    age { 56 }
    adset_id { Faker::Lorem.words(number: 3).join(' ') }
    platform { %w[yt fb ig].sample }
    campaign_id { Faker::Lorem.words(number: 5).join(' ') }
    ip_address { Faker::Internet.public_ip_v4_address }
    location { Faker::Address.city }
    trusted_form_url { Faker::Internet.url(host: 'example.com') }
    video_type { %w[other dom].sample }
    lead_date { Faker::Date.between(from: 1.day.ago, to: 1.year.ago) }
  end
end

# == Schema Information
#
# Table name: leads
#
#  id                      :bigint           not null, primary key
#  ad                      :string
#  age                     :integer
#  agent_sold              :string
#  branch_of_service       :string
#  carrier_sold            :string
#  client_age              :integer
#  contact_time_of_day     :string
#  crm                     :string
#  crm_date                :string
#  crm_status              :string
#  crm_user                :string
#  current_retirement_plan :string
#  dob                     :date
#  email                   :string
#  employment_status       :string
#  first_name              :string
#  ip_address              :string
#  iul_goal                :string
#  last_name               :string
#  lead_age                :integer
#  lead_date               :date
#  lead_form_at            :datetime
#  lead_form_name          :string
#  lead_program            :string
#  lead_type               :string
#  location                :string
#  marital_status          :string
#  military_status         :string
#  monthly_contribution    :string
#  needed_coverage         :string
#  otp_code                :string
#  outside_company         :string
#  page_url                :string
#  phone                   :string
#  platform                :string
#  policy_sold             :boolean
#  premium_sold            :string
#  real_owner_name         :string
#  resold_on               :date
#  resold_owner            :string
#  retirement_age          :integer
#  ringy_code              :string
#  ringy_status            :string
#  rr_state                :string
#  sold_on                 :date
#  state                   :string
#  the_row                 :string
#  trusted_form_url        :string
#  type                    :string
#  unique                  :boolean
#  utm_adset               :string
#  utm_campaign            :string
#  utm_content             :string
#  utm_medium              :string
#  utm_site_source         :string
#  utm_source              :string
#  verified_lead           :boolean
#  veteran                 :boolean
#  video_type              :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  adset_id                :string
#  campaign_id             :string
#  external_lead_id        :string
#  google_click_id         :string
#  user_id                 :bigint
#
# Indexes
#
#  index_leads_on_dob         (dob)
#  index_leads_on_email       (email)
#  index_leads_on_first_name  (first_name)
#  index_leads_on_last_name   (last_name)
#  index_leads_on_phone       (phone)
#  index_leads_on_state       (state)
#  index_leads_on_type        (type)
#  index_leads_on_user_id     (user_id)
#
