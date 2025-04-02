# frozen_string_literal: true

class LeadDailySummary < ApplicationRecord
  validates :date, presence: true
  validates :lead_type, presence: true
  validates :lead_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Ensure uniqueness of date and lead_type combination
  validates :lead_type, uniqueness: { scope: :date, message: 'already has a summary for this date' }

  # Scope to filter by date range
  scope :between_dates, ->(start_date, end_date) { where(date: start_date..end_date) }

  # Scope to filter by lead type
  scope :for_lead_type, ->(lead_type) { where(lead_type: lead_type) }
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
