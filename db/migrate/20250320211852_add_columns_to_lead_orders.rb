class AddColumnsToLeadOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :lead_orders, :detail, :string
    add_column :lead_orders, :agent_name, :string
    add_column :lead_orders, :amount_cents, :integer
    add_column :lead_orders, :discount_cents, :integer
    add_column :lead_orders, :paid_cents, :integer
    add_column :lead_orders, :frequency, :integer
    add_column :lead_orders, :count, :integer
    add_column :lead_orders, :lead_program, :string
    add_column :lead_orders, :lead_type, :string
    add_column :lead_orders, :agent_email, :string
    add_column :lead_orders, :agent_phone, :string
    add_column :lead_orders, :agent_sheet, :string
    add_column :lead_orders, :url_source, :string
    add_column :lead_orders, :quantity, :integer
    add_column :lead_orders, :total_leads, :integer
    add_column :lead_orders, :bump_order, :integer
    add_column :lead_orders, :total_lead_order, :integer
    add_column :lead_orders, :order_id, :string
    add_column :lead_orders, :name_on_sheet, :string
    add_column :lead_orders, :imo, :string
    add_column :lead_orders, :notes, :string
    add_column :lead_orders, :ordered_at, :datetime

    add_index :lead_orders, :order_id
    add_index :lead_orders, :agent_email
    add_index :lead_orders, :agent_phone
  end
end
