# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdDailySpendSummary, type: :model do
  let(:valid_attributes) do
    attributes_for(:ad_daily_spend_summary)
  end

  describe 'validations' do
    context 'with valid attributes' do
      it 'is valid' do
        summary = described_class.new(valid_attributes)
        expect(summary).to be_valid
      end
    end

    context 'with missing date' do
      it 'is invalid' do
        summary = described_class.new(valid_attributes.merge(date: nil))
        expect(summary).not_to be_valid
        expect(summary.errors[:date]).to include("can't be blank")
      end
    end

    context 'with missing lead_type' do
      it 'is invalid' do
        summary = described_class.new(valid_attributes.merge(lead_type: nil))
        expect(summary).not_to be_valid
        expect(summary.errors[:lead_type]).to include("can't be blank")
      end
    end

    context 'with missing platform' do
      it 'is invalid' do
        summary = described_class.new(valid_attributes.merge(platform: nil))
        expect(summary).not_to be_valid
        expect(summary.errors[:platform]).to include("can't be blank")
      end
    end

    context 'with missing ad_spend' do
      it 'is invalid' do
        summary = described_class.new(valid_attributes.merge(ad_spend: nil))
        expect(summary).not_to be_valid
        expect(summary.errors[:ad_spend]).to include("can't be blank")
      end
    end

    context 'with negative ad_spend' do
      it 'is invalid' do
        summary = described_class.new(valid_attributes.merge(ad_spend: -1.0))
        expect(summary).not_to be_valid
        expect(summary.errors[:ad_spend]).to include('must be greater than or equal to 0')
      end
    end

    context 'with duplicate date, lead_type, platform, and campaign combination' do
      before do
        # Create an existing record with the same date, lead_type, platform, and campaign
        described_class.create!(valid_attributes)
      end

      it 'is invalid' do
        summary = described_class.new(valid_attributes)
        expect(summary).not_to be_valid
        expect(summary.errors[:lead_type]).to include('already has a summary for this date')
      end
    end

    context 'with unique date, lead_type, platform, and campaign combination' do
      it 'is valid' do
        # Create a record with the valid attributes
        described_class.create!(valid_attributes)

        # Create another record with a different date
        new_attributes = valid_attributes.merge(date: Date.current + 1.day)
        summary = described_class.new(new_attributes)
        expect(summary).to be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: ad_daily_spend_summaries
#
#  id         :bigint           not null, primary key
#  ad_spend   :decimal(10, 2)   default(0.0), not null
#  campaign   :string
#  date       :date             not null
#  lead_type  :string           not null
#  platform   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  idx_on_date_lead_type_platform_campaign_567fd7b4b4  (date,lead_type,platform,campaign) UNIQUE
#  index_ad_daily_spend_summaries_on_campaign          (campaign)
#  index_ad_daily_spend_summaries_on_lead_type         (lead_type)
#  index_ad_daily_spend_summaries_on_platform          (platform)
#
