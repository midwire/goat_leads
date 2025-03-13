# frozen_string_literal: true

FactoryBot.define do
  factory :lead_order do
    user { nil }
    lead_class { 'MyString' }
    active { false }
    max_per_day { 1 }
    paused_until { '2025-03-12' }
    days_per_week { 'MyString' }
    states { 'MyString' }
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
