# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadOrder, type: :model do

  describe 'validation' do
    let(:lead_order) { create(:lead_order) }

    context 'if agent_phone number is not valid' do
      it 'generates an error' do
        lead_order.agent_phone = 'asdf'
        expect(lead_order.valid?).to be(false)
        lead_order.agent_phone = '123-444-1212'
        expect(lead_order.valid?).to be(false)
        lead_order.agent_phone = '+123-444-1212'
        expect(lead_order.valid?).to be(false)
        lead_order.agent_phone = '(123) 444-1212'
        expect(lead_order.valid?).to be(false)
        lead_order.agent_phone = '+8005551222212'
        expect(lead_order.valid?).to be(false)
      end
    end

    context 'if agent_phone number is valid' do
      it 'generates no error' do
        lead_order.agent_phone = '8005551212'
        expect(lead_order.valid?).to be(true)
        lead_order.agent_phone = '18005551212'
        expect(lead_order.valid?).to be(true)
      end
    end
  end

  describe 'scopes' do
    describe '.active' do
      let(:lo) { create(:lead_order) }

      it 'returns only active lead_orders' do
        create(:lead_order, :inactive)
        expect(described_class.active).to eq([lo])
      end
    end

    describe '.with_unreached_daily_cap_of' do
      let!(:lo) { create(:lead_order, max_per_day: 100) }

      context 'when cap reached' do
        it 'returns no lead orders' do
          expect(described_class.with_unreached_daily_cap_of(100)).to eq([])
        end
      end

      context 'when cap not reached' do
        it 'returns lead orders where max_per_day cap is met' do
          expect(described_class.with_unreached_daily_cap_of(99)).to eq([lo])
        end
      end
    end

    describe '.with_unreached_daily_cap' do
      let!(:lo) { create(:lead_order, max_per_day: 3) }

      context 'when cap reached' do
        it 'returns no lead orders' do
          3.times do
            lead = create(:veteran_lead_premium, lead_order: lo)
            lo.assign_lead(lead)
          end
          expect(described_class.with_unreached_daily_cap).to eq([])
        end
      end

      context 'when cap not reached' do
        it 'returns lead orders where max_per_day cap is met' do
          expect(described_class.with_unreached_daily_cap).to eq([lo])
        end
      end
    end

    describe '.with_unreached_total_cap' do
      let!(:lo) { create(:lead_order, total_lead_order: 3, max_per_day: 3) }

      context 'when cap reached' do
        it 'returns no lead orders' do
          3.times do
            lead = create(:veteran_lead_premium, lead_order: lo)
            lo.assign_lead(lead)
          end
          expect(described_class.with_unreached_total_cap).to eq([])
        end
      end

      context 'when cap not reached' do
        it 'returns lead orders where total_lead_order cap is met' do
          expect(described_class.with_unreached_total_cap).to eq([lo])
        end
      end
    end

    describe '.for_lead_type' do
      let(:lead_order) { create(:lead_order, lead_class: 'MyLeadClass') }

      it 'returns only lead orders matching lead type' do
        expect(described_class.for_lead_type(lead_order.lead_class)).to eq([lead_order])
        expect(described_class.for_lead_type('bogus')).to eq([])
      end
    end

    describe '.not_canceled' do
      let(:lead_order) { create(:lead_order, canceled_at: nil) }

      it 'returns only un-canceled lead orders' do
        create(:lead_order, canceled_at: Time.current)
        expect(described_class.not_canceled).to eq([lead_order])
      end
    end

    describe '.not_expired' do
      it 'returns only un-expired lead orders' do
        create(:lead_order, expire_on: 1.day.ago)
        lo = create(:lead_order, expire_on: 1.day.from_now)
        expect(described_class.not_expired).to eq([lo])
      end
    end

    describe '.for_day_of_week' do
      it 'returns only matching lead orders' do
        lo = create(:lead_order, days_per_week: %w[mon])
        create(:lead_order, days_per_week: %w[tue fri])
        expect(described_class.for_day_of_week('mon')).to eq([lo])
      end
    end

    describe '.fulfilled' do
      it 'returns fulfilled lead orders' do
        lo = create(:lead_order, fulfilled_at: 1.day.ago)
        create(:lead_order, fulfilled_at: nil)
        expect(described_class.fulfilled).to eq([lo])
      end
    end

    describe '.not_fulfilled' do
      it 'returns fulfilled lead orders' do
        create(:lead_order, fulfilled_at: 1.day.ago)
        lo = create(:lead_order, fulfilled_at: nil)
        expect(described_class.not_fulfilled).to eq([lo])
      end
    end

    describe '.for_user' do
      it 'returns lead orders for the passed user' do
        lo = create(:lead_order)
        create(:lead_order)
        expect(described_class.for_user(lo.user)).to eq([lo])
      end
    end

    describe '.for_state' do
      it 'returns lead orders matching the passed state' do
        lo = create(:lead_order, states: %w[wy])
        create(:lead_order, states: %w[tx])
        # NOTE: lead order should capitalize the states
        expect(described_class.for_state('WY')).to eq([lo])
      end
    end

    describe '.by_last_lead_delivered' do
      it 'sorts lead orders asc by last_lead_delivered_at with nulls first' do
        lo_1 = create(:lead_order, last_lead_delivered_at: 1.minute.ago)
        lo_2 = create(:lead_order, last_lead_delivered_at: nil)
        lo_3 = create(:lead_order, last_lead_delivered_at: 1.second.ago)
        expect(described_class.by_last_delivered).to eq(
          [lo_2, lo_1, lo_3]
        )
      end
    end

    describe '.eligible_for_lead' do
      let!(:lead_order) { create(:lead_order, states: %w[wa or]) }
      let(:lead) { create(:veteran_lead_premium, state: 'Washington') }

      it 'returns lead orders that apply the the passed lead' do
        expect(
          described_class.eligible_for_lead(lead)
        ).to eq([lead_order])
      end
    end
  end
end

# == Schema Information
#
# Table name: lead_orders
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE)
#  agent_email            :string
#  agent_name             :string
#  agent_phone            :string
#  agent_sheet            :string
#  amount_cents           :integer
#  bump_order             :integer          default(0)
#  canceled_at            :datetime
#  count                  :integer
#  days_per_week          :text             default(["mon", "tue", "wed", "thu", "fri", "sat", "sun"]), is an Array
#  detail                 :string
#  discount_cents         :integer          default(0)
#  expire_on              :date
#  frequency              :integer
#  fulfilled_at           :datetime
#  ghl_api_key            :string
#  google_sheet_url       :string
#  imo                    :string
#  last_lead_delivered_at :datetime
#  lead_class             :string
#  lead_program           :string
#  lead_type              :string
#  max_per_day            :integer
#  name_on_sheet          :string
#  notes                  :string
#  ordered_at             :datetime
#  paid_cents             :integer          default(0)
#  paused_until           :date
#  quantity               :integer
#  ringy_auth_token       :string
#  ringy_sid              :string
#  send_email             :boolean
#  send_text              :boolean
#  states                 :text             default([]), is an Array
#  total_lead_order       :integer
#  total_leads            :integer
#  url_source             :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  order_id               :string
#  user_id                :bigint           not null
#
# Indexes
#
#  index_lead_orders_on_active                  (active)
#  index_lead_orders_on_agent_email             (agent_email)
#  index_lead_orders_on_agent_phone             (agent_phone)
#  index_lead_orders_on_canceled_at             (canceled_at)
#  index_lead_orders_on_days_per_week           (days_per_week) USING gin
#  index_lead_orders_on_expire_on               (expire_on)
#  index_lead_orders_on_fulfilled_at            (fulfilled_at)
#  index_lead_orders_on_last_lead_delivered_at  (last_lead_delivered_at)
#  index_lead_orders_on_lead_class              (lead_class)
#  index_lead_orders_on_max_per_day             (max_per_day)
#  index_lead_orders_on_order_id                (order_id) UNIQUE
#  index_lead_orders_on_states                  (states) USING gin
#  index_lead_orders_on_user_id                 (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
