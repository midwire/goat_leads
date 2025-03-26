class AddUtmAdPlatformToLeads < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :utm_ad_platform, :string
  end
end
