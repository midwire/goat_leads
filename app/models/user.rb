# frozen_string_literal: true

# Most users will be agents but may also be an admin or manager
class User < ApplicationRecord
  include EmailAddressVerification
  uses_email_address_verification
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :leads, dependent: :nullify
  has_many :lead_orders, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :video_types, with: ->(e) { e.map(&:downcase) }
  normalizes :licensed_states, with: ->(e) { e.map(&:upcase) }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :licensed_states, state_abbreviation: true, allow_blank: true
  validates :phone, phone_number: true, allow_blank: true

  # Adds predicate methods for each role
  enum :role, { agent: 0, manager: 1, admin: 2 }
  enum :status, { available: 0, paused: 1 }

  scope :verified, -> { where.not(email_verified_at: nil) }
  scope :by_deliver_priority, -> { order(deliver_priority: :asc) }
  scope :by_last_delivered, -> { order(arel_table[:last_lead_delivered_at].asc.nulls_first) }
  scope :licensed_in_state, lambda { |state_abbr|
    where('licensed_states @> ARRAY[?]::text[]', state_abbr)
  }
  scope :eligible_for_video_type, lambda { |video_type|
    where('video_types @> ARRAY[?]::text[]', video_type)
  }
  scope :eligible_for_lead_type, lambda { |lead_type|
    # TODO: Make this account for active, matching lead orders
    # Not to exceed the daily cap for lead order
    joins(:lead_orders)
        .merge(LeadOrder.active)
        .merge(LeadOrder.not_canceled)
        .merge(LeadOrder.not_expired)
        .merge(LeadOrder.for_lead_type(lead_type))
        .merge(LeadOrder.for_day_of_week)
    # where('lead_types @> ARRAY[?]::text[]', lead_type)
  }
  scope :eligible_for_lead, lambda { |lead|
    agent
        .verified
        .available
        .licensed_in_state(lead.rr_state)
        .eligible_for_lead_type(lead.type)
        # .eligible_for_video_type(lead.video_type)
        .by_deliver_priority
        .by_last_delivered
  }

  def verify!
    update!(email_verified_at: Time.current.utc)
  end

  def verified?
    email_verified_at.present?
  end

  # Account for all matching lead orders and compare max_per_day to matching delivered leads
  def fulfilled_leads_for_lead_type?(lead_type, dow = Date.current.strftime('%a').downcase)
    matching_leads = leads.delivered_today_by_type(lead_type)
    return false if matching_leads.empty?

    delivered_count = matching_leads.count

    lead_orders
        .for_lead_type(lead_type)
        .for_day_of_week(dow)
        .with_unreached_daily_cap_of(matching_leads.count)

    return true if lead_orders.empty?

    fulfilled = true
    lead_orders.each do |order|
      fulfilled &= delivered_count >= order.max_per_day
    end
    fulfilled
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  daily_lead_cap         :integer
#  deliver_priority       :integer          default(0)
#  email_address          :string           not null
#  email_verified_at      :datetime
#  first_name             :string
#  ghl_api_key            :string
#  google_sheet_url       :string
#  last_lead_delivered_at :datetime
#  last_name              :string
#  lead_types             :text             default([]), is an Array
#  licensed_states        :text             default([]), is an Array
#  notes                  :text
#  password_digest        :string           not null
#  phone                  :string
#  ringy_auth_token       :string
#  ringy_sid              :string
#  role                   :integer          default("agent")
#  send_email             :boolean          default(TRUE)
#  send_text              :boolean          default(FALSE)
#  status                 :integer          default("available")
#  total_lead_cap         :integer
#  video_types            :text             default([]), is an Array
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  external_id            :string
#
# Indexes
#
#  index_users_on_deliver_priority        (deliver_priority)
#  index_users_on_email_address           (email_address) UNIQUE
#  index_users_on_email_verified_at       (email_verified_at)
#  index_users_on_external_id             (external_id)
#  index_users_on_last_lead_delivered_at  (last_lead_delivered_at)
#  index_users_on_lead_types              (lead_types) USING gin
#  index_users_on_licensed_states         (licensed_states) USING gin
#  index_users_on_role                    (role)
#  index_users_on_status                  (status)
#  index_users_on_video_types             (video_types) USING gin
#
