# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def verify_email(user_id)
    @user = User.find(user_id).decorate
    mail(to: @user.email_address, subject: 'Please verify your email')
  end

  def new_user_welcome(user_id)
    @user = User.find(user_id).decorate
    mail(to: @user.email_address, subject: "Welcome to #{Settings.whitelabel.site_title}")
  end
end
