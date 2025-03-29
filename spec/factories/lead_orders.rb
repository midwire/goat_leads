# frozen_string_literal: true

FactoryBot.define do
  factory :lead_order do
    user
    lead_class { 'VeteranLeadPremium' }
    active { true }
    # max_per_day { 100 }
    total_lead_order { 200 }
    states { %w[wy or] }
    amount_cents { nil }
    order_id do
      random_string = (0...30).map { rand(65..90).chr }.join + (0...30).map { rand(10).to_s }.join
      random_string.chars.sample(30).join
    end
    google_sheet_url { 'https://docs.example.com/spreadsheets/d/17Q3XFm2asdfzSZJd6Tvj2-kRB1CSasdf2K7BKLGHRPQ14' }

    trait :inactive do
      active { false }
    end

    trait :veteran do
      lead_class { 'VeteranLeadPremium' }
    end

    trait :iul do
      lead_class { 'IndexUniversalLifeLeadPremium' }
    end

    trait :fex do
      lead_class { 'FinalExpenseLeadPremium' }
    end

    trait :mp do
      lead_class { 'MortgageProtectionLeadPremium' }
    end
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
