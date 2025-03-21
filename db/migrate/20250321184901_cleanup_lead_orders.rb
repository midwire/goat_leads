class CleanupLeadOrders < ActiveRecord::Migration[8.0]
  def change
    remove_column :lead_orders, :email, :string
    remove_column :lead_orders, :phone, :string
    remove_index :lead_orders, :order_id
    add_index :lead_orders, :order_id, unique: true
  end
end
