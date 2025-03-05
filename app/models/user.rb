# frozen_string_literal: true

# Most users will be agents but may also be an admin or manager
class User < ApplicationRecord
  include EmailAddressVerification
  uses_email_address_verification
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :leads, dependent: :nullify

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Adds predicate methods for each role
  enum :role, { agent: 0, manager: 1, admin: 2 }

  scope :verified, -> { where.not(email_verified_at: nil) }

  def verify!
    update!(email_verified_at: Time.current)
  end

  def verified?
    email_verified_at.present?
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
