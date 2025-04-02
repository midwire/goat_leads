# frozen_string_literal: true

class LeadVolumeReport
  def initialize(start_date: 30.days.ago.to_date, end_date: Date.current)
    @start_date = start_date
    @end_date = end_date
  end

  def leads_by_type_per_day
    summaries = Lead.between_dates(@start_date, @end_date)
    data = summaries.group_by_day(:created_at).group(:type).count

    # Transform the hash
    data.transform_keys { |k| [k[1], k[0]] }
  end

  def leads_by_type_per_day_table
    rollup = Lead.counts_rollup(@start_date, @end_date)
    rollup.each do |lead_type|
      lead_type['lead_category'] = shorten_category(lead_type['lead_category'])
    end
    rollup
  end

  private

  def shorten_category(cat)
    return 'VET Lead Count' if cat.match?(/Veteran/)
    return 'IUL Lead Count' if cat.match?(/Index/)
    return 'MP Lead Count' if cat.match?(/Mortgage/)

    'FEX Lead Count' if cat.match?(/FinalExpense/)
  end
end
