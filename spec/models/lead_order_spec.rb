# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadOrder, type: :model do
  subject(:lead_order) { create(:lead_order, :with_user) }

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
