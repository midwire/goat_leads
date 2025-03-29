# frozen_string_literal: true

class LeadOrder < ApplicationRecord
  include LeadOrderScopes

  before_validation :upcase_states
  before_validation :downcase_days_per_week

  monetize :amount_cents, :discount_cents, :paid_cents, allow_nil: true

  belongs_to :user
  has_many :leads, dependent: :nullify

  enum :frequency, { one_time: 0, recurring: 1 }

  normalizes :agent_email, with: ->(e) { e.strip.downcase }

  # TODO: Turn on this validation once we move to native lead_orders instead of external ones
  # validates :states, presence: true
  validates :lead_class,
    :total_lead_order,
    :days_per_week,
    :order_id, # has unique index
    presence: true
  validates :agent_phone, phone_number: true, allow_blank: true
  validates :agent_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  validate :validate_permitted_states
  validate :validate_permitted_days_of_week
  validate :validate_lead_caps

  # TODO: Refactor this or get rid of it
  def assign_lead(lead)
    now = Time.current
    lead.update(delivered_at: now)
    leads << lead
    update(last_lead_delivered_at: now)
  end

  def ringy_enabled?
    ringy_sid.present? && ringy_auth_token.present?
  end

  def webhook_enabled?
    webhook_url.present?
  end

  def sms_enabled?
    send_text.present? && agent_phone.present?
  end

  def email_enabled?
    send_email.present? && agent_email.present?
  end

  def ghl_enabled?
    user.ghl_integration?
  end

  def leads_received_count
    leads.count
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
    return nil if max_per_day.blank?

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
#  webhook_url            :string
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
