class MakeLeadsUseSti < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :type, :string
    add_index :leads, :type
  end
end
