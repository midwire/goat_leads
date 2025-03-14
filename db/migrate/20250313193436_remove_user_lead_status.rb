class RemoveUserLeadStatus < ActiveRecord::Migration[8.0]
  def change
    # Using user.status enum instead
    remove_column :users, :lead_status, :boolean, default: true
  end
end
