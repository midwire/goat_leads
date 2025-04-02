# frozen_string_literal: true

require 'rails_helper'

module Hooks
  RSpec.describe 'AdDailySpendSummaries', type: :request do
    let(:url) { '/hooks/ad_daily_spend_summaries' }
    let(:summary) { create(:ad_daily_spend_summary) }
    let(:valid_params) do
      {
        ad_daily_spend_summary: attributes_for(:ad_daily_spend_summary)
      }
    end

    describe 'POST /hooks/ad_daily_spend_summaries' do
      context 'when creating a new summary' do
        context 'with valid params' do
          it 'returns a created response' do
            post url, params: valid_params
            expect(response).to have_http_status(:created)
          end

          it 'creates a AdDailySpendSummary' do
            expect do
              post url, params: valid_params
            end.to change(AdDailySpendSummary, :count).by(1)
          end
        end

        context 'with invalid params' do
          it 'returns a unprocessable response' do
            valid_params[:ad_daily_spend_summary][:lead_type] = nil
            post url, params: valid_params
            expect(response).to have_http_status(:unprocessable_content)
          end
        end
      end

      context 'when updating an existing summary' do
        let(:valid_params) do
          {
            ad_daily_spend_summary: summary.attributes
          }
        end

        context 'with valid params' do
          it 'returns a success response' do
            post url, params: valid_params
            expect(response).to have_http_status(:ok)
          end

          it 'does not create a new AdDailySpendSummary' do
            expect(summary).to be_present
            expect do
              post url, params: valid_params
            end.not_to change(AdDailySpendSummary, :count)
          end
        end

        context 'with invalid params' do
          it 'returns a unprocessable response' do
            valid_params[:ad_daily_spend_summary][:ad_spend] = nil
            post url, params: valid_params
            expect(response).to have_http_status(:unprocessable_content)
          end
        end
      end
    end
  end
end
