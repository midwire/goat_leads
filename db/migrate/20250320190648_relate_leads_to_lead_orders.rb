class RelateLeadsToLeadOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :lead_order_id, :bigint
    add_index :leads, :lead_order_id
  end
end
