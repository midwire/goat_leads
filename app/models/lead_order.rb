# frozen_string_literal: true

class LeadOrder < ApplicationRecord
  before_validation :upcase_states
  before_validation :downcase_days_per_week

  belongs_to :user

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :states, presence: true
  validates :lead_class, presence: true
  validates :days_per_week, presence: true
  validates :phone, phone_number: true, allow_blank: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  validate :validate_permitted_states
  validate :validate_permitted_days_of_week

  scope :active, -> { where(active: true) }
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
#  id            :bigint           not null, primary key
#  active        :boolean
#  canceled_at   :datetime
#  days_per_week :text             default(["mon", "tue", "wed", "thu", "fri", "sat", "sun"]), is an Array
#  email         :string
#  expire_on     :date
#  lead_class    :string
#  max_per_day   :integer
#  paused_until  :date
#  phone         :string
#  states        :text             default([]), is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_lead_orders_on_active      (active)
#  index_lead_orders_on_expire_on   (expire_on)
#  index_lead_orders_on_lead_class  (lead_class)
#  index_lead_orders_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
