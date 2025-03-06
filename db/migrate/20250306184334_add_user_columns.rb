class AddUserColumns < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :notes, :text
    add_column :users, :status, :integer, default: 0
    add_column :users, :google_sheet_url, :string
    add_column :users, :ghl_api_key, :string
    add_column :users, :ringy_sid, :string
    add_column :users, :ringy_auth_token, :string
    add_column :users, :external_id, :string
    add_column :users, :send_text, :boolean, default: false
    add_column :users, :send_email, :boolean, default: true
    add_column :users, :daily_lead_cap, :integer
    add_column :users, :total_lead_cap, :integer
    add_index :users, :status
    add_index :users, :external_id
  end
end
