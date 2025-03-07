class AddMoreLeadTrackingData < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :user_agent, :string
    add_column :leads, :utm_owner, :string
    add_column :leads, :utm_id, :string
    add_column :leads, :utm_term, :string
    add_column :leads, :fbclid, :string
    add_column :leads, :full_name, :string
    add_column :leads, :is_dropoff, :boolean
  end
end
