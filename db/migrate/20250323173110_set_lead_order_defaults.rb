class SetLeadOrderDefaults < ActiveRecord::Migration[8.0]
  def change
    change_column_default :lead_orders, :active, from: nil, to: true
    change_column_default :lead_orders, :discount_cents, from: nil, to: 0
    change_column_default :lead_orders, :paid_cents, from: nil, to: 0
    change_column_default :lead_orders, :bump_order, from: nil, to: 0
  end
end
