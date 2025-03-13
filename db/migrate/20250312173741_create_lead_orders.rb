class CreateLeadOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :lead_orders do |t|
      t.references :user, null: false, foreign_key: true
      t.date :expire_on
      t.datetime :canceled_at
      t.string :lead_class
      t.string :email
      t.string :phone
      t.boolean :active
      t.integer :max_per_day
      t.date :paused_until
      t.column :days_per_week, :text, array: true, default: %w[mon tue wed thu fri sat sun]
      t.column :states, :text, array: true, default: []

      t.timestamps
    end
    add_index :lead_orders, :expire_on
    add_index :lead_orders, :lead_class
    add_index :lead_orders, :active
  end
end
