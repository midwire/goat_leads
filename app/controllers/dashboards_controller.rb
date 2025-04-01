# frozen_string_literal: true

class DashboardsController < ApplicationController
  def show
    if @current_user.admin?
      @lead_order_count = LeadOrder.count
      @lead_count = Lead.count
      @lead_fulfilled_count = LeadOrder.fulfilled.count
      @unassigned_lead_count = Lead.unassigned.count
      @leads_by_day = Lead.group_by_day(:created_at).count
      @leads_by_type_per_day = leads_by_type_per_day
    else
      @lead_order_count = @current_user.lead_orders.count
      @lead_count = @current_user.leads.count
      @lead_fulfilled_count = @current_user.lead_orders.fulfilled.count
      @leads_by_day = @current_user.leads.group_by_day(:created_at).count
    end
  end

  private

  def leads_by_type_per_day
    # Prepare data for the line chart: leads per day by type
    leads = Lead.group(:type).group_by_day(:created_at).count.transform_keys do |type, date|
      [type, date.to_date] # Transform keys to [type, date] pairs
    end

    # Convert to Chartkick-compatible format: { "Type1" => { date1 => count1, date2 => count2 }, "Type2" => { ... } }
    Lead.distinct.pluck(:type).index_with do |type|
      leads.select do |k, _|
        k.first == type
      end.transform_keys(&:last).transform_values { |v| v }
    end
  end
end
