# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadOrder, type: :model do
  subject(:lead_order) { create(:lead_order) }

  describe 'validation' do
    context 'if phone number is not valid' do
      it 'generates an error' do
        lead_order.phone = 'asdf'
        expect(lead_order.valid?).to be(false)
        lead_order.phone = '123-444-1212'
        expect(lead_order.valid?).to be(false)
        lead_order.phone = '+123-444-1212'
        expect(lead_order.valid?).to be(false)
        lead_order.phone = '(123) 444-1212'
        expect(lead_order.valid?).to be(false)
        lead_order.phone = '+8005551222212'
        expect(lead_order.valid?).to be(false)
      end
    end

    context 'if phone number is valid' do
      it 'generates no error' do
        lead_order.phone = '8005551212'
        expect(lead_order.valid?).to be(true)
        lead_order.phone = '18005551212'
        expect(lead_order.valid?).to be(true)
      end
    end
  end

  describe 'scopes' do
    context 'active' do
      let(:lo) { create(:lead_order) }

      it 'returns only active lead_orders' do
        create(:lead_order, :inactive)
        expect(described_class.active).to eq([lo])
      end
    end

    context 'with_unreached_daily_cap_of' do
      context 'when cap reached' do
        it 'returns no lead orders' do
          expect(described_class.with_unreached_daily_cap_of(100)).to eq([])
        end
      end

      context 'when cap not reached' do
        it 'returns lead orders where max_per_day cap is met' do
          expect(described_class.with_unreached_daily_cap_of(99)).to eq([lead_order])
        end
      end
    end

    context 'for_lead_type' do
      it 'returns only lead orders matching lead type' do
        expect(described_class.for_lead_type(lead_order.lead_class)).to eq([lead_order])
        expect(described_class.for_lead_type('bogus')).to eq([])
      end
    end

    context 'not_canceled' do
      it 'returns only un-canceled lead orders' do
        create(:lead_order, canceled_at: Time.current)
        expect(described_class.not_canceled).to eq([lead_order])
      end
    end

    context 'for_day_of_week' do
      it 'returns only matching lead orders' do
        create(:lead_order, days_per_week: %w[tue fri])
        expect(described_class.for_day_of_week('mon')).to eq([lead_order])
      end
    end
  end
end

# == Schema Information
#
# Table name: lead_orders
#
#  id            :bigint           not null, primary key
#  active        :boolean
#  canceled_at   :datetime
#  days_per_week :text             default(["mon", "tue", "wed", "thu", "fri", "sat", "sun"]), is an Array
#  email         :string
#  expire_on     :date
#  lead_class    :string
#  max_per_day   :integer
#  paused_until  :date
#  phone         :string
#  states        :text             default([]), is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_lead_orders_on_active      (active)
#  index_lead_orders_on_expire_on   (expire_on)
#  index_lead_orders_on_lead_class  (lead_class)
#  index_lead_orders_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
