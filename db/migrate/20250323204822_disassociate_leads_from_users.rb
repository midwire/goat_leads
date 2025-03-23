class DisassociateLeadsFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :leads, :user_id, :bigint
  end
end
