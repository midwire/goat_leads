# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'scopes' do
    context 'licensed_in_state' do
      let!(:user_1) { create_user(states: %w[WA TX]) }
      let!(:user_2) { create_user(states: %w[TX]) }
      let!(:user_3) { create_user(states: %w[WA]) }

      it 'returns users licensed in the given state' do
        expect(described_class.licensed_in_state('WA')).to eq([user_1, user_3])
        expect(described_class.licensed_in_state('TX')).to eq([user_1, user_2])
      end
    end

    context 'eligible_for_video_type' do
      let!(:user_1) { create_user(video_types: %w[Dom other]) }
      let!(:user_2) { create_user(video_types: %w[DOM]) }
      let!(:user_3) { create_user(video_types: %w[Other]) }

      it 'returns users eligible for video type' do
        expect(described_class.eligible_for_video_type('dom')).to eq([user_1, user_2])
        expect(described_class.eligible_for_video_type('other')).to eq([user_1, user_3])
      end
    end

    context 'eligible_for_lead_type' do
      let!(:user_1) { create_user(lead_types: %w[VeteranLead FinalExpenseLead]) }
      let!(:user_2) { create_user(lead_types: %w[VeteranLead]) }
      let!(:user_3) { create_user(lead_types: %w[FinalExpenseLead]) }

      it 'returns users eligible for lead type' do
        expect(described_class.eligible_for_lead_type('VeteranLead')).to eq([user_1, user_2])
        expect(described_class.eligible_for_lead_type('FinalExpenseLead')).to eq([user_1, user_3])
      end
    end

    context 'by_deliver_priority' do
      let!(:user_1) { create_user(lead_types: %w[VeteranLead FinalExpenseLead], deliver_priority: 1) }
      let!(:user_2) { create_user(lead_types: %w[VeteranLead], deliver_priority: -1) }
      let(:user_3) { create_user(lead_types: %w[FinalExpenseLead]) }

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
  end

  private

  def create_user(states: nil, lead_types: nil, video_types: nil, deliver_priority: 0)
    create(
      :user,
      :confirmed,
      lead_status: true,
      deliver_priority: deliver_priority,
      licensed_states: states || %w[WA TX],
      lead_types: lead_types || %w[VeteranLead FinalExpenseLead],
      video_types: video_types || %w[dom other]
    )
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
#  lead_status            :boolean          default(TRUE)
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
#  index_users_on_lead_status             (lead_status)
#  index_users_on_lead_types              (lead_types) USING gin
#  index_users_on_licensed_states         (licensed_states) USING gin
#  index_users_on_role                    (role)
#  index_users_on_status                  (status)
#  index_users_on_video_types             (video_types) USING gin
#
