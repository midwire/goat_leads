# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :set_admin_data, if: -> { @current_user.admin? }
  before_action :set_agent_data, if: -> { @current_user.agent? }

  def show
  end

  private

  def lead_volume_report
    LeadVolumeReport.new(
      start_date: Date.current.beginning_of_year,
      end_date: Date.current
    )
  end

  def leads_counts_by_type
    lead_volume_report.leads_by_type_per_day_table
  end

  def set_admin_data
    @lead_order_count = LeadOrder.count
    @lead_count = Lead.count
    @lead_fulfilled_count = LeadOrder.fulfilled.count
    @unassigned_lead_count = Lead.unassigned.count
    @leads_by_day = Lead.group_by_day(:created_at).count
    @leads_by_type_per_day = leads_counts_by_type
  end

  def set_agent_data
    @lead_order_count = @current_user.lead_orders.count
    @lead_count = @current_user.leads.count
    @lead_fulfilled_count = @current_user.lead_orders.fulfilled.count
    @leads_by_day = @current_user.leads.group_by_day(:created_at).count
  end
end
