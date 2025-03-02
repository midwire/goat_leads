# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "testuser#{n}@example.com" }
    password { FactoryBot::DEFAULT_TEST_PASSWORD }
    password_confirmation { FactoryBot::DEFAULT_TEST_PASSWORD }

    trait :admin do
      role { 2 }
    end

    trait :manager do
      role { 1 }
    end

    trait :admin do
      role { 0 }
    end

    trait :confirmed do
      email_verified_at { Time.current.utc }
      # Notification is slow to render, can skip to speed up user creation by a few seconds
      # after(:build, &:skip_confirmation_notification!)
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  email_address     :string           not null
#  email_verified_at :datetime
#  password_digest   :string           not null
#  role              :integer          default("agent")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_users_on_email_address      (email_address) UNIQUE
#  index_users_on_email_verified_at  (email_verified_at)
#  index_users_on_role               (role)
#
