# frozen_string_literal: true

# app/reports/lead_daily_summary_report.rb
class LeadDailySummaryReport
  def initialize(start_date: 30.days.ago.to_date, end_date: Date.current)
    @start_date = start_date
    @end_date = end_date
  end

  def data_by_lead_type
    summaries = LeadDailySummary.between_dates(@start_date, @end_date)
    lead_types = summaries.distinct.pluck(:lead_type)

    lead_types.index_with do |lead_type|
      summaries.for_lead_type(lead_type).each_with_object({}) do |summary, dates|
        dates[summary.date] = { count: summary.lead_count, cost: summary.total_cost }
      end
    end
  end

  def total_leads_by_day
    summaries = LeadDailySummary.between_dates(@start_date, @end_date)
    summaries.group(:date).sum(:lead_count)
  end

  def total_cost_by_day
    summaries = LeadDailySummary.between_dates(@start_date, @end_date)
    summaries.group(:date).sum(:total_cost)
  end
end
