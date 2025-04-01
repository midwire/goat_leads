class CreateAdDailySpendSummaries < ActiveRecord::Migration[8.0]
  def change
    create_table :ad_daily_spend_summaries do |t|
      t.date :date, null: false
      t.string :platform, null: false
      t.string :campaign, null: true
      t.string :lead_type, null: false
      t.decimal :ad_spend, precision: 10, scale: 2, null: false, default: 0.0

      t.timestamps
    end
    add_index :ad_daily_spend_summaries, %i[date lead_type platform campaign], unique: true
    add_index :ad_daily_spend_summaries, :platform
    add_index :ad_daily_spend_summaries, :campaign
    add_index :ad_daily_spend_summaries, :lead_type
  end
end
