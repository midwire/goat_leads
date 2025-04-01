FactoryBot.define do
  factory :lead_daily_summary do
    date { "2025-04-01" }
    lead_type { "MyString" }
    lead_count { 1 }
    total_cost { "9.99" }
  end
end

# == Schema Information
#
# Table name: lead_daily_summaries
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  lead_count :integer          default(0), not null
#  lead_type  :string           not null
#  total_cost :decimal(10, 2)   default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_lead_daily_summaries_on_date_and_lead_type  (date,lead_type) UNIQUE
#
