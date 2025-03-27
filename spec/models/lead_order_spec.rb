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

    describe '.by_delivery_priority' do
      let(:user_1) { create(:user, role: :agent) }
      let(:user_2) { create(:user, role: :agent) }
      let(:current_time) { Time.current }

      # Helper to create a LeadOrder with specific attributes
      def create_lead_order(user:, total_lead_order:, ordered_at:, last_lead_delivered_at: nil,
        delivered_leads: 0)
        lead_order = create(
          :lead_order,
          user: user,
          total_lead_order: total_lead_order,
          ordered_at: ordered_at,
          last_lead_delivered_at: last_lead_delivered_at,
          active: true
        )
        # Create delivered leads if specified
        if delivered_leads > 0
          create_list(:veteran_lead_premium, delivered_leads, lead_order: lead_order,
            delivered_at: current_time)
        end
        lead_order
      end

      before do
        # Freeze time for consistent calculations
        Timecop.freeze(current_time)
      end

      after do
        Timecop.return
      end

      context 'with varying priority factors' do
        let!(:lead_order_1) do
          # Larger order, behind schedule, long wait since last lead
          create_lead_order(
            user: user_1,
            total_lead_order: 100, # W = 100
            ordered_at: current_time - 2.days, # time_ratio = 2/3
            last_lead_delivered_at: current_time - 3.days, # R = 1 + (3/1) = 4
            delivered_leads: 10 # fulfillment_ratio = 10/100 = 0.1, B = 1 + (2/3 - 0.1) = 1.5667
          )
          # Score = 100 * 1.5667 * 4 ≈ 626.68
        end

        let!(:lead_order_2) do
          # Smaller order, on schedule, recent lead
          create_lead_order(
            user: user_2,
            total_lead_order: 50, # W = 50
            ordered_at: current_time - 1.day, # time_ratio = 1/3
            last_lead_delivered_at: current_time - 6.hours, # R = 1 (below 1 day threshold)
            delivered_leads: 20 # fulfillment_ratio = 20/50 = 0.4, B = 1 (on schedule)
          )
          # Score = 50 * 1 * 1 = 50
        end

        it 'sorts lead orders by priority score (descending)' do
          ordered_lead_orders = described_class.by_delivery_priority
          expect(ordered_lead_orders[0]).to eq(lead_order_1) # Higher score: 626.68
          expect(ordered_lead_orders[-1]).to eq(lead_order_2) # Lower score: 50
        end
      end

      context 'when scores are equal (tiebreaker)' do
        let!(:lead_order_1) do
          # Same score as lead_order_2, but older last_lead_delivered_at
          create_lead_order(
            user: user_1,
            total_lead_order: 50,
            ordered_at: current_time - 1.day,
            last_lead_delivered_at: current_time - 2.days, # Older
            delivered_leads: 20
          )
          # Score = 50 * 1 * 1 = 50
        end

        let!(:lead_order_2) do
          # Same score as lead_order_1, but more recent last_lead_delivered_at
          create_lead_order(
            user: user_2,
            total_lead_order: 50,
            ordered_at: current_time - 1.day,
            last_lead_delivered_at: current_time - 1.day, # More recent
            delivered_leads: 20
          )
          # Score = 50 * 1 * 1 = 50
        end

        it 'sorts by last_lead_delivered_at (ascending) as a tiebreaker' do
          ordered_lead_orders = described_class.by_delivery_priority
          expect(ordered_lead_orders[0]).to eq(lead_order_1) # Older last_lead_delivered_at
          expect(ordered_lead_orders[-1]).to eq(lead_order_2) # More recent last_lead_delivered_at
        end
      end

      context 'when last_lead_delivered_at is NULL' do
        let!(:lead_order_1) do
          # No leads delivered yet (NULL last_lead_delivered_at)
          create_lead_order(
            user: user_1,
            total_lead_order: 50,
            ordered_at: current_time - 1.day,
            last_lead_delivered_at: nil,
            delivered_leads: 0
          )
          # R = 1 (NULL treated as 0 in calculation), B = 1 + (1/3 - 0) ≈ 1.333, Score = 50 * 1.333 * 1 ≈ 66.67
        end

        let!(:lead_order_2) do
          create_lead_order(
            user: user_2,
            total_lead_order: 50,
            ordered_at: current_time - 1.day,
            last_lead_delivered_at: current_time - 6.hours,
            delivered_leads: 20
          )
          # Score = 50 * 1 * 1 = 50
        end

        it 'treats NULL last_lead_delivered_at as earliest (NULLS FIRST)' do
          ordered_lead_orders = described_class.by_delivery_priority
          # NULL last_lead_delivered_at, but higher score
          expect(ordered_lead_orders[0]).to eq(lead_order_1)
          expect(ordered_lead_orders[-1]).to eq(lead_order_2)
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
#  webhook_url            :string
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
