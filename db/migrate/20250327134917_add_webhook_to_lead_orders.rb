class AddWebhookToLeadOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :lead_orders, :webhook_url, :string
  end
end
