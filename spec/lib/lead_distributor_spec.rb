# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadDistributor do
  describe '.assign_lead' do
    let(:lead) { create(:veteran_lead_premium) }

    context 'with no eligible users' do
      it 'returns nil when no users match criteria' do
        create(:user, licensed_states: ['TX'], lead_types: ['auto'], video_types: ['tutorial'])
        result = described_class.assign_lead(lead)
        expect(result).to be_nil
        expect(lead.reload.user).to be_nil
      end

      it 'returns nil when all users are inactive' do
        create(:user, :inactive)
        result = described_class.assign_lead(lead)
        expect(result).to be_nil
      end

      it 'returns nil with invalid lead' do
        invalid_lead = build(:veteran_lead_premium, rr_state: nil)
        result = described_class.assign_lead(invalid_lead)
        expect(result).to be_nil
      end

      it 'returns nil with delivered lead' do
        user = create(:user, :confirmed)
        lead = build(:veteran_lead_premium, user: user)
        result = described_class.assign_lead(lead)
        expect(result).to be_nil
      end
    end

    context 'with eligible users' do
      let!(:user_1) { create(:user, :confirmed, last_lead_delivered_at: 2.days.ago) }
      let!(:user_2) { create(:user, :confirmed, last_lead_delivered_at: 1.day.ago) }
      let!(:high_priority_user) { create(:user, :confirmed, :high_priority, last_lead_delivered_at: nil) }

      it 'assigns lead to user with highest priority' do
        result = described_class.assign_lead(lead)
        expect(result).to eq(high_priority_user)
        expect(lead.reload.user).to eq(high_priority_user)
        expect(high_priority_user.reload.last_lead_delivered_at).to be_present
      end

      it 'uses round-robin among same-priority users' do
        high_priority_user.destroy # Remove high priority user for this test

        # First assignment should go to user_1 (oldest last_lead_delivered_at)
        result_1 = described_class.assign_lead(lead)
        expect(result_1).to eq(user_1)

        # Create new lead and assign - should go to user_2
        new_lead = create(:veteran_lead_premium)
        result_2 = described_class.assign_lead(new_lead)
        expect(result_2).to eq(user_2)
      end

      it 'respects all matching criteria' do
        mismatched_user = create(:user,
          licensed_states: ['TX'],
          lead_types: ['auto'],
          video_types: ['tutorial'])

        result = described_class.assign_lead(lead)
        expect(result).not_to eq(mismatched_user)
        expect(result).to eq(high_priority_user)
      end
    end

    context 'with database errors' do
      it 'handles transaction failures gracefully' do
        allow_any_instance_of(User).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
        create(:user, :confirmed)

        result = described_class.assign_lead(lead)
        expect(Rails.logger).to have_received(:error).with(/Failed to assign lead/)
        expect(result).to be_nil
        expect(lead.reload.user).to be_nil
      end
    end

    context 'with multiple attempts' do
      it 'tries next user if first assignment fails' do
        count = 0
        allow_any_instance_of(User).to receive(:lock!) do
          count += 1
          fail ActiveRecord::LockWaitTimeout if count == 1
          # Optionally, define behavior for subsequent calls
        end
        create(:user, :confirmed) # First user that will fail
        successful_user = create(:user, :confirmed)

        result = described_class.assign_lead(lead)
        expect(result).to eq(successful_user)
      end
    end
  end
end
