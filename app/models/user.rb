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

  # enum :role, { agent: 0, manager: 1, admin: 2 }

  scope :verified, -> { where.not(email_verified_at: nil) }

  def email
    email_address
  end

  def display_name
    fname = object.first_name
    lname = object.last_name
    return object.email if fname.blank? && lname.blank?

    [fname, lname].join(' ')
  end

  def verify!
    update!(email_verified_at: Time.current)
  end
end

# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  email_address     :string           not null
#  password_digest   :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  email_verified_at :datetime
#
# Indexes
#
#  index_users_on_email_address      (email_address) UNIQUE
#  index_users_on_email_verified_at  (email_verified_at)
#
