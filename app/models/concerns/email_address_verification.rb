# frozen_string_literal: true

module EmailAddressVerification
  extend ActiveSupport::Concern

  class_methods do
    def uses_email_address_verification
      generates_token_for(:email_verification_token, expires_in: 15.minutes)
    end

    def find_by_email_verification_token(token)
      find_by_token_for(:email_verification_token, token)
    end
  end

  def email_verification_token
    generate_token_for(:email_verification_token)
  end
end
