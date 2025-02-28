# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def verify_email(user)
    @user = user
    mail(to: @user.email, subject: 'Please verify your email')
  end
end
