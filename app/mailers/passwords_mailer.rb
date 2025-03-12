# frozen_string_literal: true

class PasswordsMailer < ApplicationMailer
  def reset(user_id)
    @user = User.find(user_id).decorate
    mail subject: 'Reset your password', to: @user.email_address
  end
end
