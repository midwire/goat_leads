# frozen_string_literal: true

class Lead < ApplicationRecord
  before_save :set_rr_state
  before_save :set_full_name

  belongs_to :lead_order, optional: true
  has_one :user, through: :lead_order

  normalizes :email, with: ->(e) { e.strip.downcase }
  normalizes :state, with: ->(e) { e.strip.titleize }
  normalizes :phone, with: ->(e) { e.strip.tr('^0-9', '') }
  normalizes :rr_state, with: ->(e) { e.strip.upcase }

  validates :first_name,
    :last_name,
    :phone,
    :email,
    :state,
    :dob,
    presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, phone_number: true
  validates :state, state: true
  validates :rr_state, state_abbreviation: true

  scope :unassigned, -> { where(delivered_at: nil) }
  scope :oldest_first, -> { order(lead_date: :asc) }
  scope :delivered_today_by_type, lambda { |lead_class|
    today = Date.current
    where(type: lead_class)
        .where(delivered_at: today.beginning_of_day..today.end_of_day)
  }

  # Scope to filter by date range
  scope :between_dates, ->(start_date, end_date) { where(created_at: start_date..end_date) }

  # Scope to filter by lead type
  scope :for_lead_type, ->(lead_type) { where(type: lead_type) }

  scope :counts_rollup, lambda { |start_date, end_date|
    # Lead.select(
    #   "CASE WHEN type LIKE '%Spanish' THEN type ELSE REGEXP_REPLACE(type, '(Aged|Otp|Premium|Standard)$', '') END AS lead_category",
    #   'COUNT(*) AS lead_count',
    #   "COUNT(*)::float / (DATE_PART('day', '#{end_date}'::timestamp - '#{start_date}'::timestamp) + 1) AS avg_leads_per_day"
    # )
    #     .where(created_at: start_date..end_date)
    #     .group("CASE WHEN type LIKE '%Spanish' THEN type ELSE REGEXP_REPLACE(type, '(Aged|Otp|Premium|Standard)$', '') END")
    #     .order('lead_category')

    sql = <<-SQL
      WITH daily_counts AS (
        SELECT
          CASE
            WHEN type LIKE '%Spanish' THEN type
            ELSE REGEXP_REPLACE(type, '(Aged|Otp|Premium|Standard)$', '')
          END AS lead_category,
          DATE(created_at) AS lead_date,
          COUNT(*) AS daily_lead_count
        FROM
          leads
        WHERE
          created_at BETWEEN :start_date AND :end_date
        GROUP BY
          CASE
            WHEN type LIKE '%Spanish' THEN type
            ELSE REGEXP_REPLACE(type, '(Aged|Otp|Premium|Standard)$', '')
          END,
          DATE(created_at)
      ),
      category_totals AS (
        SELECT
          lead_category,
          SUM(daily_lead_count) AS lead_count,
          AVG(daily_lead_count) AS avg_leads_per_day
        FROM
          daily_counts
        GROUP BY
          lead_category
      )
      SELECT
        lead_category,
        lead_count,
        avg_leads_per_day,
        (lead_count::float / SUM(lead_count) OVER ()) * 100 AS percent_of_total
      FROM
        category_totals
      ORDER BY
        lead_category
    SQL

    # Execute the raw SQL with sanitized parameters
    result = ActiveRecord::Base.connection.exec_query(
      ActiveRecord::Base.sanitize_sql_array([sql, { start_date: start_date, end_date: end_date }])
    )
    result.to_a
  }

  ########################################
  # Abstract Methods

  # Don't allow Lead base class to be instantiated
  def initialize(*args)
    fail('Cannot instantiate Lead base class directly.') if instance_of?(Lead)

    super
  end

  def to_ringy_format
    fail('Define the "to_ringy_format" method for the child class.')
  end

  def to_webhook_format
    fail('Define the "to_webhook_format" method for the child class.')
  end

  ########################################

  def delivered?
    delivered_at.present?
  end

  # Transforms the lead to an array for Agent display
  # Each Lead child class must define 'spreadsheet_data'
  def to_array
    decorated = decorate
    spreadsheet_data.values.map { |method| decorated.public_send(method) }
  end

  def lead_class
    type
  end

  private

  def set_rr_state
    self.rr_state = State.code_from_name(state)
  end

  def set_full_name
    return if full_name.present?

    self.full_name = "#{first_name} #{last_name}"
  end
end

# == Schema Information
#
# Table name: leads
#
#  id                      :bigint           not null, primary key
#  ad                      :string
#  address                 :string
#  age                     :integer
#  agent_sold              :string
#  amt_requested           :string
#  beneficiary             :string
#  beneficiary_name        :string
#  branch_of_service       :string
#  carrier_sold            :string
#  city                    :string
#  client_age              :integer
#  contact_time_of_day     :string
#  crm                     :string
#  crm_date                :string
#  crm_status              :string
#  crm_user                :string
#  current_retirement_plan :string
#  delivered_at            :datetime
#  desired_monthly_contrib :string
#  desired_retirement_age  :string
#  dob                     :date
#  dob_day                 :string
#  dob_month               :string
#  dob_year                :string
#  email                   :string
#  employment_status       :string
#  favorite_hobby          :string
#  fbclid                  :string
#  first_name              :string
#  full_name               :string
#  gender                  :string
#  has_life_insurance      :string
#  health_history          :boolean
#  ip_address              :string
#  is_dropoff              :boolean
#  iul_goal                :string
#  last_name               :string
#  lead_age                :integer
#  lead_date               :date
#  lead_form_at            :datetime
#  lead_form_name          :string
#  lead_program            :string
#  lead_quality            :string
#  location                :string
#  marital_status          :string
#  military_status         :string
#  monthly_contribution    :string
#  mortgage_balance        :string
#  mortgage_payment        :string
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
#  utm_ad_platform         :string
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
#  zip                     :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  adset_id                :string
#  campaign_id             :string
#  external_lead_id        :string
#  google_click_id         :string
#  lead_form_id            :string
#  lead_order_id           :bigint
#  utm_id                  :string
#
# Indexes
#
#  index_leads_on_delivered_at   (delivered_at)
#  index_leads_on_dob            (dob)
#  index_leads_on_email          (email)
#  index_leads_on_first_name     (first_name)
#  index_leads_on_last_name      (last_name)
#  index_leads_on_lead_order_id  (lead_order_id)
#  index_leads_on_phone          (phone)
#  index_leads_on_state          (state)
#  index_leads_on_type           (type)
#
