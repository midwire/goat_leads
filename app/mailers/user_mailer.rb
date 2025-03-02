# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def verify_email(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Please verify your email')
  end
end
