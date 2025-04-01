# frozen_string_literal: true

module DashboardsHelper
  def lead_types_without_orders(
    lead_types: Lead.group(:type).count,
    lead_order_types: LeadOrder.group(:lead_class).count
  )
    unmatched_types = (lead_types.keys - lead_order_types.keys).flatten.sort
    lead_types.slice(*unmatched_types)
  end
end
