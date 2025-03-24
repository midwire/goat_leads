# frozen_string_literal: true

class LeadOrder < ApplicationRecord
  before_validation :upcase_states
  before_validation :downcase_days_per_week

  monetize :amount_cents, :discount_cents, :paid_cents, allow_nil: true

  belongs_to :user
  has_many :leads, dependent: :nullify

  enum :frequency, { one_time: 0, recurring: 1 }

  normalizes :agent_email, with: ->(e) { e.strip.downcase }

  # validates :states, presence: true
  validates :lead_class, presence: true
  validates :total_lead_order, presence: true
  validates :days_per_week, presence: true
  validates :agent_phone, phone_number: true, allow_blank: true
  validates :agent_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :order_id, presence: true # has a unique index

  validate :validate_permitted_states
  validate :validate_permitted_days_of_week
  validate :validate_lead_caps

  scope :active, -> { where(active: true) }
  scope :fulfilled, -> { where.not(fulfilled_at: nil) }
  scope :not_fulfilled, -> { where(fulfilled_at: nil) }
  scope :for_user, ->(user) { where(user_id: user.respond_to?(:id) ? user.id : user) }
  scope :not_canceled, -> { where(canceled_at: nil) }
  scope :not_expired, lambda {
    where(
      arel_table[:expire_on].eq(nil).or(
        arel_table[:expire_on].gt(Time.current)
      )
    )
  }
  scope :for_lead_type, ->(lead_type) { where(lead_class: lead_type) }
  scope :for_day_of_week, lambda { |dow = Date.current.strftime('%a').downcase|
    where('days_per_week @> ARRAY[?]::text[]', dow)
  }
  scope :for_state, lambda { |state_abbr|
    where('states @> ARRAY[?]::text[]', state_abbr)
  }
  scope :with_unreached_daily_cap_of, lambda { |cap|
    where(
      arel_table[:max_per_day].eq(nil).or(
        arel_table[:max_per_day].eq(0).or(
          arel_table[:max_per_day].gt(cap)
        )
      )
    )
  }
  scope :with_unreached_total_cap, lambda {
    sql = <<-SQL.squish
      LEFT JOIN (
        SELECT lead_order_id, COUNT(*) AS leads_delivered_total
        FROM leads
        GROUP BY lead_order_id
      ) ld_total ON ld_total.lead_order_id = lead_orders.id
    SQL
    joins(sql).where(
      <<-SQL.squish
        (
          COALESCE(ld_total.leads_delivered_total, 0) < lead_orders.total_lead_order
        )
      SQL
    )
  }
  scope :with_unreached_daily_cap, lambda { |date = Time.current.strftime('%Y-%m-%d')|
    raw_sql = <<-SQL.squish
      LEFT JOIN (
        SELECT lead_order_id, COUNT(*) AS leads_delivered_today
        FROM leads
        WHERE DATE(delivered_at) = ?
        GROUP BY lead_order_id
      ) ld_daily ON ld_daily.lead_order_id = lead_orders.id
    SQL
    sql = sanitize_sql_array([raw_sql, date])
    joins(sql).where(
      <<-SQL.squish
        (
          lead_orders.max_per_day IS NULL
          OR COALESCE(ld_daily.leads_delivered_today, 0) < lead_orders.max_per_day
        )
      SQL
    )
  }

  # SORTING
  scope :by_last_delivered, lambda {
    order(arel_table[:last_lead_delivered_at].asc.nulls_first)
  }
  scope :by_delivery_priority, lambda {
    # TODO: Calculate the delivery priority and use it here
  }

  # LEAD ELIGIBILITY
  # This scope uses most of the others for lead eligibility
  scope :eligible_for_lead, lambda { |lead|
    joins(:user)
        .merge(User.agent)
        # .merge(User.verified)  # TODO: Enable this after we get users verified
        .merge(User.available)
        .not_canceled
        .not_expired
        .not_fulfilled
        .for_state(lead.rr_state)
        .for_day_of_week
        .for_lead_type(lead.type)
        .with_unreached_daily_cap
        .with_unreached_total_cap
        .by_last_delivered
    # .by_delivery_priority # TODO: Enable this when ready
  }

  def assign_lead(lead)
    now = Time.current
    lead.update(delivered_at: now)
    leads << lead
    update(last_lead_delivered_at: now)
  end

  private

  def upcase_states
    self.states = states.map(&:upcase) if states.present?
  end

  def downcase_days_per_week
    self.days_per_week = days_per_week.map(&:downcase) if days_per_week.present?
  end

  def validate_permitted_states
    return if states.blank?

    invalid_states = states - State.all
    return unless invalid_states.any?

    errors.add(:states,
      "contains invalid values: #{invalid_states.join(', ')}. Permitted values are: #{State.all}")
  end

  def validate_permitted_days_of_week
    return if days_per_week.blank?

    invalid_days_per_week = days_per_week - permitted_days_per_week
    return unless invalid_days_per_week.any?

    msg = <<~STRING
      contains invalid values: '#{invalid_days_per_week.join(', ')}'.
      Permitted values are: #{permitted_days_per_week}
    STRING
    errors.add(:days_per_week, msg)
  end

  # total_lead_order must be greater than max_per_day
  def validate_lead_caps
    return nil if total_lead_order.to_i >= max_per_day.to_i

    errors.add(:total_lead_order, "must be greater or equal to max_per_day: #{max_per_day.to_i}")
  end
end

# == Schema Information
#
# Table name: lead_orders
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE)
#  agent_email            :string
#  agent_name             :string
#  agent_phone            :string
#  agent_sheet            :string
#  amount_cents           :integer
#  bump_order             :integer          default(0)
#  canceled_at            :datetime
#  count                  :integer
#  days_per_week          :text             default(["mon", "tue", "wed", "thu", "fri", "sat", "sun"]), is an Array
#  detail                 :string
#  discount_cents         :integer          default(0)
#  expire_on              :date
#  frequency              :integer
#  fulfilled_at           :datetime
#  ghl_api_key            :string
#  google_sheet_url       :string
#  imo                    :string
#  last_lead_delivered_at :datetime
#  lead_class             :string
#  lead_program           :string
#  lead_type              :string
#  max_per_day            :integer
#  name_on_sheet          :string
#  notes                  :string
#  ordered_at             :datetime
#  paid_cents             :integer          default(0)
#  paused_until           :date
#  quantity               :integer
#  ringy_auth_token       :string
#  ringy_sid              :string
#  send_email             :boolean
#  send_text              :boolean
#  states                 :text             default([]), is an Array
#  total_lead_order       :integer
#  total_leads            :integer
#  url_source             :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  order_id               :string
#  user_id                :bigint           not null
#
# Indexes
#
#  index_lead_orders_on_active                  (active)
#  index_lead_orders_on_agent_email             (agent_email)
#  index_lead_orders_on_agent_phone             (agent_phone)
#  index_lead_orders_on_canceled_at             (canceled_at)
#  index_lead_orders_on_days_per_week           (days_per_week) USING gin
#  index_lead_orders_on_expire_on               (expire_on)
#  index_lead_orders_on_fulfilled_at            (fulfilled_at)
#  index_lead_orders_on_last_lead_delivered_at  (last_lead_delivered_at)
#  index_lead_orders_on_lead_class              (lead_class)
#  index_lead_orders_on_max_per_day             (max_per_day)
#  index_lead_orders_on_order_id                (order_id) UNIQUE
#  index_lead_orders_on_states                  (states) USING gin
#  index_lead_orders_on_user_id                 (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
