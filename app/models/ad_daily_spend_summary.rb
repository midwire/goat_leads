# frozen_string_literal: true

class AdDailySpendSummary < ApplicationRecord
  validates :date, presence: true
  validates :lead_type, presence: true
  validates :platform, presence: true
  validates :ad_spend, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Ensure uniqueness of date lead_type platform and campaign combination
  validates :lead_type,
    uniqueness: { scope: %i[date platform campaign], message: 'already has a summary for this date' }

  # Scope to filter by date range
  scope :between_dates, ->(start_date, end_date) { where(date: start_date..end_date) }

  # Scope to filter by lead type
  scope :for_lead_type, ->(lead_type) { where(lead_type: lead_type) }
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
