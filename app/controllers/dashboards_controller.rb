# frozen_string_literal: true

class DashboardsController < ApplicationController
  def show
    if @current_user.admin?
      @lead_order_count = LeadOrder.count
      @lead_count = Lead.count
      @lead_fulfilled_count = LeadOrder.fulfilled.count
      @unassigned_lead_count = Lead.unassigned.count
      @leads_by_day = Lead.group_by_day(:created_at).count
    else
      @lead_order_count = @current_user.lead_orders.count
      @lead_count = @current_user.leads.count
      @lead_fulfilled_count = @current_user.lead_orders.fulfilled.count
      @unassigned_lead_count = 0
      @leads_by_day = @current_user.leads.group_by_day(:created_at).count
    end
  end
end
