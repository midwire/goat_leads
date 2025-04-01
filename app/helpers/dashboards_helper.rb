# frozen_string_literal: true

module DashboardsHelper
  def lead_types_without_orders(
    lead_types: Lead.group(:type).count,
    lead_order_types: LeadOrder.group(:lead_class).count
  )
    lead_types.keys - lead_order_types.keys
  end
end
