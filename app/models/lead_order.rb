# frozen_string_literal: true

class LeadOrder < ApplicationRecord
  before_validation :upcase_states
  before_validation :downcase_days_per_week

  monetize :amount_cents, :discount_cents, :paid_cents, allow_nil: true

  belongs_to :user
  has_many :leads, dependent: :nullify

  enum :frequency, { one_time: 0, recurring: 1 }

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :states, presence: true
  validates :lead_class, presence: true
  validates :days_per_week, presence: true
  validates :phone, phone_number: true, allow_blank: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :order_id, presence: true, uniqueness: true

  validate :validate_permitted_states
  validate :validate_permitted_days_of_week

  scope :active, -> { where(active: true) }
  scope :fulfilled, -> { where.not(fulfilled_at: nil) }
  scope :for_user, ->(user) { where(user_id: user.respond_to?(:id) ? user.id : user) }
  scope :not_canceled, -> { where(canceled_at: nil) }
  scope :not_expired, lambda {
    where(
      arel_table[:expire_on].eq(nil).or(
        arel_table[:expire_on].gt(Time.current)
      )
    )
  }
  arel_table[:expires_at].gt(Time.current)
  scope :for_lead_type, ->(lead_type) { where(lead_class: lead_type) }
  scope :for_day_of_week, lambda { |dow = Date.current.strftime('%a').downcase|
    where('days_per_week @> ARRAY[?]::text[]', dow)
  }
  scope :with_unreached_daily_cap_of, lambda { |cap|
    where(
      arel_table[:max_per_day].eq(nil).or(
        arel_table[:max_per_day].eq(0).or(
          arel_table[:max_per_day].gteq(cap)
        )
      )
    )
  }
  scope :for_lead_not_fulfilled, lambda { |lead, user|
    where.not(fulfilled_at: nil)
        .for_user(user)
        .active
        .for_lead_type(lead.type)
  }

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
end

# == Schema Information
#
# Table name: lead_orders
#
#  id               :bigint           not null, primary key
#  active           :boolean
#  agent_email      :string
#  agent_name       :string
#  agent_phone      :string
#  agent_sheet      :string
#  amount_cents     :integer
#  bump_order       :integer
#  canceled_at      :datetime
#  count            :integer
#  days_per_week    :text             default(["mon", "tue", "wed", "thu", "fri", "sat", "sun"]), is an Array
#  detail           :string
#  discount_cents   :integer
#  email            :string
#  expire_on        :date
#  frequency        :integer
#  fulfilled_at     :datetime
#  ghl_api_key      :string
#  google_sheet_url :string
#  imo              :string
#  lead_class       :string
#  lead_program     :string
#  lead_type        :string
#  max_per_day      :integer
#  name_on_sheet    :string
#  notes            :string
#  ordered_at       :datetime
#  paid_cents       :integer
#  paused_until     :date
#  phone            :string
#  quantity         :integer
#  ringy_auth_token :string
#  ringy_sid        :string
#  send_email       :boolean
#  send_text        :boolean
#  states           :text             default([]), is an Array
#  total_lead_order :integer
#  total_leads      :integer
#  url_source       :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  order_id         :string
#  user_id          :bigint           not null
#
# Indexes
#
#  index_lead_orders_on_active        (active)
#  index_lead_orders_on_agent_email   (agent_email)
#  index_lead_orders_on_agent_phone   (agent_phone)
#  index_lead_orders_on_expire_on     (expire_on)
#  index_lead_orders_on_fulfilled_at  (fulfilled_at)
#  index_lead_orders_on_lead_class    (lead_class)
#  index_lead_orders_on_order_id      (order_id)
#  index_lead_orders_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
