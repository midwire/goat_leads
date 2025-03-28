class AddGhlIntegrationToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :ghl_company_id, :string
    add_column :users, :ghl_location_id, :string
    add_column :users, :ghl_access_token, :string
    add_column :users, :ghl_refresh_token, :string
    add_column :users, :ghl_refresh_date, :date
  end
end
