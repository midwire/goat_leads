# frozen_string_literal: true

FactoryBot.define do
  factory :lead_order do
    user
    lead_class { 'VeteranLeadPremium' }
    active { true }
    max_per_day { 100 }
    states { %w[wy or] }
    amount_cents { nil }

    trait :inactive do
      active { false }
    end
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
#  index_lead_orders_on_order_id      (order_id) UNIQUE
#  index_lead_orders_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
