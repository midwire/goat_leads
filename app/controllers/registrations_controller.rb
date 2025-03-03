# frozen_string_literal: true

class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  layout 'welcome'

  wrap_parameters :user, include: User.attribute_names + %i[password password_confirmation]
  rate_limit to: 10, within: 3.minutes, with: lambda {
    redirect_to new_session_url, alert: 'Try again later.'
  }

  def new
    redirect_to root_url, notice: 'You are already signed in.' if authenticated?
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      # start_new_session_for user
      # redirect_to after_authentication_url, notice: 'Signed up.'
      UserMailer.verify_email(user.id).deliver_now
      redirect_to new_session_url, notice: 'Check your email for verification instructions.'
    else
      redirect_to new_registration_url,
        alert: user.errors.full_messages.to_sentence
    end
  end

  private

  def user_params
    params.expect(user: %i[email_address password password_confirmation])
  end
end
