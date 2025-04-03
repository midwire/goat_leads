class AdZapIdToAdDailySpend < ActiveRecord::Migration[8.0]
  def change
    add_column :ad_daily_spend_summaries, :zap_id, :string
  end
end
