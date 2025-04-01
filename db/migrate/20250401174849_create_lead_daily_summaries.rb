class CreateLeadDailySummaries < ActiveRecord::Migration[8.0]
  def change
    create_table :lead_daily_summaries do |t|
      t.date :date, null: false
      t.string :lead_type, null: false
      t.integer :lead_count, null: false, default: 0
      t.decimal :total_cost, precision: 10, scale: 2, null: false, default: 0.0

      t.timestamps
    end
    add_index :lead_daily_summaries, %i[date lead_type], unique: true
  end
end
