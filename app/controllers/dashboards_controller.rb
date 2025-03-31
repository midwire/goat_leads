# frozen_string_literal: true

class DashboardsController < ApplicationController
  def show
    @lead_order_count = LeadOrder.count
    @lead_count = Lead.count
    @lead_fulfilled_count = LeadOrder.fulfilled.count
    @unassigned_lead_count = Lead.unassigned.count
  end
end
