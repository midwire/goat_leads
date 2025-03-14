# frozen_string_literal: true

class Lead < ApplicationRecord
  before_save :set_rr_state

  belongs_to :user, optional: true

  normalizes :email, with: ->(e) { e.strip.downcase }
  normalizes :phone, with: ->(e) { e.strip.tr('^0-9', '') }
  normalizes :rr_state, with: ->(e) { e.strip.upcase }

  validates :first_name,
    :last_name,
    :phone,
    :email,
    :state,
    :video_type,
    :lead_type,
    presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, phone_number: true
  validates :state, state: true
  validates :rr_state, state_abbreviation: true

  scope :unassigned, -> { where(user_id: nil) }
  scope :oldest_first, -> { order(lead_date: :asc) }
  scope :delivered_today_by_type, lambda { |lead_type|
    today = Date.current
    where(type: lead_type)
        .where(delivered_at: today.beginning_of_day..today.end_of_day)
  }

  # Don't allow Lead base class to be instantiated
  def initialize(*args)
    fail('Cannot instantiate Lead base class directly.') if instance_of?(Lead)

    super
  end

  def delivered?
    user.present?
  end

  private

  def set_rr_state
    self.rr_state = State.code_from_name(state)
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
#  delivered_at            :datetime
#  dob                     :date
#  email                   :string
#  employment_status       :string
#  fbclid                  :string
#  first_name              :string
#  full_name               :string
#  ip_address              :string
#  is_dropoff              :boolean
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
#  user_agent              :string
#  utm_adset               :string
#  utm_campaign            :string
#  utm_content             :string
#  utm_medium              :string
#  utm_owner               :string
#  utm_site_source         :string
#  utm_source              :string
#  utm_term                :string
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
#  utm_id                  :string
#
# Indexes
#
#  index_leads_on_delivered_at  (delivered_at)
#  index_leads_on_dob           (dob)
#  index_leads_on_email         (email)
#  index_leads_on_first_name    (first_name)
#  index_leads_on_last_name     (last_name)
#  index_leads_on_phone         (phone)
#  index_leads_on_state         (state)
#  index_leads_on_type          (type)
#  index_leads_on_user_id       (user_id)
#
