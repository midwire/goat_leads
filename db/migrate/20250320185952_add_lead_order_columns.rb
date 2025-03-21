class AddLeadOrderColumns < ActiveRecord::Migration[8.0]
  def change
    add_column :lead_orders, :google_sheet_url, :string
    add_column :lead_orders, :ghl_api_key, :string
    add_column :lead_orders, :ringy_sid, :string
    add_column :lead_orders, :ringy_auth_token, :string
    add_column :lead_orders, :send_text, :boolean
    add_column :lead_orders, :send_email, :boolean
  end
end
