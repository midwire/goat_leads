# frozen_string_literal: true

# This webhook is for incoming daily ad spend
class Hooks::AdDailySpendSummariesController < WebhookController
  before_action :find_existing_summary

  # POST /hooks/ad_daily_spend_summaries
  def create
    if @existing_summary.present?
      update_existing_summary
    else
      create_new_summary
    end
  end

  private

  def create_new_summary
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

  def update_existing_summary
    if @existing_summary.update(ad_spend_params)
      head :ok
    else
      Rails.logger.error(
        ">>> Failed to update AdSpendDailySummary: - #{@existing_summary&.errors&.full_messages}"
      )
      head :unprocessable_content
    end
  end

  def ad_spend_params
    params.expect(ad_daily_spend_summary: %i[date lead_type platform campaign ad_spend zap_id])
  end

  def find_existing_summary
    @existing_summary = AdDailySpendSummary.find_by(
      date: ad_spend_params[:date],
      lead_type: ad_spend_params[:lead_type],
      platform: ad_spend_params[:platform],
      campaign: ad_spend_params[:campaign]
    )
  end
end
