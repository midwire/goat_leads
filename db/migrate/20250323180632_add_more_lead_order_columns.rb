class AddMoreLeadOrderColumns < ActiveRecord::Migration[8.0]
  def change
    add_column :lead_orders, :last_lead_delivered_at, :datetime
    add_index :lead_orders, :last_lead_delivered_at
    add_index :lead_orders, :canceled_at
    add_index :lead_orders, :states, using: :gin
    add_index :lead_orders, :days_per_week, using: :gin
    add_index :lead_orders, :max_per_day
  end
end
