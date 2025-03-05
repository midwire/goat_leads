# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lead, type: :model do
  # Can't instantiate Lead base class so use VeteranLead
  subject(:lead) { create(:veteran_lead) }

  describe 'validation' do
    context 'if state is not valid' do
      it 'generates an error' do
        lead.state = 'asdf'
        expect(lead.valid?).to be(false)
        lead.state = 'XX'
        expect(lead.valid?).to be(false)
      end
    end

    context 'if state is valid state name' do
      it 'generates no error' do
        lead.state = 'Washington'
        expect(lead.valid?).to be(true)
        lead.state = 'alabama'
        expect(lead.valid?).to be(true)
      end
    end

    context 'if state is valid state abbreviation' do
      it 'generates an error' do
        lead.state = 'al'
        expect(lead.valid?).to be(false)
        lead.state = 'WA'
        expect(lead.valid?).to be(false)
      end
    end

    context 'if phone number is not valid' do
      it 'generates an error' do
        lead.phone = 'asdf'
        expect(lead.valid?).to be(false)
      end
    end

    context 'if phone number is valid' do
      it 'generates no error' do
        lead.phone = '8005551212'
        expect(lead.valid?).to be(true)
        lead.phone = '123-444-1212'
        expect(lead.valid?).to be(true)
        lead.phone = '+123-444-1212'
        expect(lead.valid?).to be(true)
        lead.phone = '(123) 444-1212'
        expect(lead.valid?).to be(true)
      end
    end
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
