# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'scopes' do
    context 'licensed_in_state' do
      let!(:user_1) { create(:user, licensed_states: %w[WA TX]) }
      let!(:user_2) { create(:user, licensed_states: %w[TX]) }
      let!(:user_3) { create(:user, licensed_states: %w[WA]) }

      it 'returns users licensed in the given state' do
        expect(described_class.licensed_in_state('WA')).to eq([user_1, user_3])
        expect(described_class.licensed_in_state('TX')).to eq([user_1, user_2])
      end
    end

    context 'eligible_for_video_type' do
      let!(:user_1) { create(:user, video_types: %w[Dom other]) }
      let!(:user_2) { create(:user, video_types: %w[DOM]) }
      let!(:user_3) { create(:user, video_types: %w[Other]) }

      it 'returns users eligible for video type' do
        expect(described_class.eligible_for_video_type('dom')).to eq([user_1, user_2])
        expect(described_class.eligible_for_video_type('other')).to eq([user_1, user_3])
      end
    end

    context 'eligible_for_lead_type' do
      let!(:user_1) { create(:lead_order, lead_class: 'VeteranLeadPremium').user }
      let!(:user_2) { create(:lead_order, lead_class: 'VeteranLeadPremium').user }
      let!(:user_3) { create(:lead_order, lead_class: 'FinalExpenseLeadPremium').user }

      it 'returns users eligible for lead type' do
        expect(described_class.eligible_for_lead_type('VeteranLeadPremium')).to eq([user_1, user_2])
        expect(described_class.eligible_for_lead_type('FinalExpenseLeadPremium')).to eq([user_3])
      end
    end

    context 'by_deliver_priority' do
      let!(:user_1) { create(:user, :low_priority) }
      let!(:user_2) { create(:user, :high_priority) }
      let!(:user_3) { create(:user) }

      it 'returns user with lowest priority first' do
        expect(user_3).to be_present
        expect(described_class.by_deliver_priority).to eq([user_2, user_3, user_1])
      end
    end

    context 'by_last_delivered' do
      let!(:user_1) { create(:user, last_lead_delivered_at: 1.minute.ago.utc) }
      let!(:user_2) { create(:user, last_lead_delivered_at: nil) }
      let!(:user_3) { create(:user, last_lead_delivered_at: 2.minutes.ago.utc) }

      it 'returns user with lowest priority first' do
        expect(described_class.by_last_delivered).to eq([user_2, user_3, user_1])
      end
    end

    context 'available' do
      let!(:user_1) { create(:user, status: :available) }

      it 'returns available user' do
        create(:user, status: :paused)
        expect(described_class.available).to eq([user_1])
      end
    end

    context 'paused' do
      let!(:user_1) { create(:user, status: :paused) }

      it 'returns available user' do
        create(:user, status: :available)
        expect(described_class.paused).to eq([user_1])
      end
    end
  end

  describe '.fulfilled_leads_for_lead_type?' do
    context 'when max_per_day leads have been delivered today for a lead order' do
      before do
        user.lead_orders << create(:lead_order, max_per_day: 2)
        user.leads << create(:veteran_lead_premium, delivered_at: Time.current)
        user.leads << create(:veteran_lead_premium, delivered_at: Time.current)
      end

      it 'returns true' do
        expect(user.fulfilled_leads_for_lead_type?('VeteranLeadPremium')).to be(true)
      end
    end

    context 'when max_per_day leads have not been delivered today for a lead order' do
      before do
        user.lead_orders << create(:lead_order, max_per_day: 3)
        user.leads << create(:veteran_lead_premium, delivered_at: Time.current)
        user.leads << create(:veteran_lead_premium, delivered_at: Time.current)
      end

      it 'returns false' do
        expect(user.fulfilled_leads_for_lead_type?('VeteranLeadPremium')).to be(false)
      end
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  daily_lead_cap         :integer
#  deliver_priority       :integer          default(0)
#  email_address          :string           not null
#  email_verified_at      :datetime
#  first_name             :string
#  ghl_api_key            :string
#  google_sheet_url       :string
#  last_lead_delivered_at :datetime
#  last_name              :string
#  lead_types             :text             default([]), is an Array
#  licensed_states        :text             default([]), is an Array
#  notes                  :text
#  password_digest        :string           not null
#  phone                  :string
#  ringy_auth_token       :string
#  ringy_sid              :string
#  role                   :integer          default("agent")
#  send_email             :boolean          default(TRUE)
#  send_text              :boolean          default(FALSE)
#  status                 :integer          default("available")
#  total_lead_cap         :integer
#  video_types            :text             default([]), is an Array
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  external_id            :string
#
# Indexes
#
#  index_users_on_deliver_priority        (deliver_priority)
#  index_users_on_email_address           (email_address) UNIQUE
#  index_users_on_email_verified_at       (email_verified_at)
#  index_users_on_external_id             (external_id)
#  index_users_on_last_lead_delivered_at  (last_lead_delivered_at)
#  index_users_on_lead_types              (lead_types) USING gin
#  index_users_on_licensed_states         (licensed_states) USING gin
#  index_users_on_role                    (role)
#  index_users_on_status                  (status)
#  index_users_on_video_types             (video_types) USING gin
#
