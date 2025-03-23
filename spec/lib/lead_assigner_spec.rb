# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadAssigner, type: :lib do
  describe '.assign_lead' do
    let(:lead) { create(:veteran_lead_premium, state: 'Washington') }

    context 'with no eligible lead order' do
      it 'returns nil when no lead orders match criteria' do
        create(:lead_order, states: %w[tx], lead_class: lead.type)
        result = described_class.assign_lead(lead)
        expect(result).to be_nil
        expect(lead.delivered_at).to be_nil
      end

      it 'returns nil when all lead orders are inactive' do
        create(:lead_order, :inactive)
        result = described_class.assign_lead(lead)
        expect(result).to be_nil
      end

      it 'returns nil with invalid lead' do
        invalid_lead = build(:veteran_lead_premium, rr_state: nil)
        result = described_class.assign_lead(invalid_lead)
        expect(result).to be_nil
      end

      it 'returns nil with delivered lead' do
        invalid_lead = build(:veteran_lead_premium, delivered_at: Time.current)
        result = described_class.assign_lead(invalid_lead)
        expect(result).to be_nil
      end
    end

    context 'with eligible lead orders' do
      let!(:lead_order_1) { create(:lead_order, states: %w[wa], last_lead_delivered_at: 2.days.ago) }
      let!(:lead_order_2) { create(:lead_order, states: %w[wa], last_lead_delivered_at: 1.day.ago) }
      let!(:lead_order_3) { create(:lead_order, states: %w[wa], last_lead_delivered_at: nil) }

      it 'assigns lead to lead_order with a nil delivery date' do
        result = described_class.assign_lead(lead)
        expect(result).to eq(lead_order_3)
      end

      it 'uses round-robin among eligible lead orders' do
        result_1 = described_class.assign_lead(lead)
        expect(result_1).to eq(lead_order_3)

        new_lead = create(:veteran_lead_premium)
        result_2 = described_class.assign_lead(new_lead)
        expect(result_2).to eq(lead_order_1)

        new_lead = create(:veteran_lead_premium)
        result_3 = described_class.assign_lead(new_lead)
        expect(result_3).to eq(lead_order_2)
      end

      it 'respects all matching criteria' do
        dow = 1.day.ago.strftime('%a').downcase
        mismatched_lo = create(
          :lead_order,
          states: ['TX'],
          lead_class: 'Other',
          days_per_week: [dow]
        )

        result = described_class.assign_lead(lead)
        expect(result).not_to eq(mismatched_lo)
        expect(result).to eq(lead_order_3)
      end
    end

    context 'with database errors' do
      it 'handles transaction failures gracefully' do
        allow_any_instance_of(LeadOrder).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
        create(:lead_order, states: %w[wa], last_lead_delivered_at: nil)

        result = described_class.assign_lead(lead)
        expect(Rails.logger).to have_received(:error).with(/Failed to assign lead/)
        expect(result).to be_nil
        expect(lead.reload.delivered_at).to be_nil
      end
    end

    context 'with multiple attempts' do
      it 'tries next lead order if first assignment fails' do
        count = 0
        allow_any_instance_of(LeadOrder).to receive(:lock!) do
          count += 1
          fail ActiveRecord::LockWaitTimeout if count == 1
          # Optionally, define behavior for subsequent calls
        end
        # first lead order will fail
        create(:lead_order, states: %w[wa], last_lead_delivered_at: nil)
        successful_lead_order = create(:lead_order, states: %w[wa], last_lead_delivered_at: nil)

        result = described_class.assign_lead(lead)
        expect(result).to eq(successful_lead_order)
      end
    end
  end
end
