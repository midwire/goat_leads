# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "testuser#{n}@example.com" }
    password { FactoryBot::DEFAULT_TEST_PASSWORD }
    password_confirmation { FactoryBot::DEFAULT_TEST_PASSWORD }
    licensed_states { %w[CA NY WA] }
    lead_types { %w[VeteranLeadPremium FinalExpenseLeadPremium] }
    video_types { %w[dom other] }

    trait :admin do
      role { 2 }
    end

    trait :manager do
      role { 1 }
    end

    # This is default
    trait :agent do
      role { 0 }
    end

    trait :inactive do
      status { :paused }
    end

    trait :high_priority do
      deliver_priority { -1 }
    end

    trait :low_priority do
      deliver_priority { 1 }
    end

    trait :confirmed do
      email_verified_at { Time.current.utc }
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
