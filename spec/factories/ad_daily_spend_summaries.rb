# frozen_string_literal: true

FactoryBot.define do
  factory :ad_daily_spend_summary do
    date { '2025-04-01' }
    platform { 'Google Ads' }
    campaign { 'Demand Gen' }
    lead_type { 'FinalExpenseLeadPremium' }
    ad_spend { 9.99 }
  end
end

# == Schema Information
#
# Table name: ad_daily_spend_summaries
#
#  id         :bigint           not null, primary key
#  ad_spend   :decimal(10, 2)   default(0.0), not null
#  campaign   :string
#  date       :date             not null
#  lead_type  :string           not null
#  platform   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  zap_id     :string
#
# Indexes
#
#  idx_on_date_lead_type_platform_campaign_567fd7b4b4  (date,lead_type,platform,campaign) UNIQUE
#  index_ad_daily_spend_summaries_on_campaign          (campaign)
#  index_ad_daily_spend_summaries_on_lead_type         (lead_type)
#  index_ad_daily_spend_summaries_on_platform          (platform)
#
