class AddFulfilledToLeadOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :lead_orders, :fulfilled_at, :datetime
    add_index :lead_orders, :fulfilled_at
  end
end
