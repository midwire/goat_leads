class AddDeliveryDateToLeads < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :delivered_at, :datetime
    add_index :leads, :delivered_at
  end
end
