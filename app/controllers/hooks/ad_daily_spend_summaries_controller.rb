# frozen_string_literal: true

# This webhook is for incoming daily ad spend
class Hooks::AdDailySpendSummariesController < WebhookController
  # POST /hooks/ad_daily_spend_summaries
  def create
    summary = AdDailySpendSummary.new(ad_spend_params)
    if summary.save
      head :created
    else
      Rails.logger.error(
        ">>> Failed to create AdSpendDailySummary: - #{summary&.errors&.full_messages}"
      )
      head :unprocessable_content
    end
  end

  private

  def ad_spend_params
    params.expect(ad_daily_spend_summary: %i[date lead_type platform campaign ad_spend])
  end
end
