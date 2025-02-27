# frozen_string_literal: true

class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: lambda {
    redirect_to new_session_url, alert: 'Try again later.'
  }

  def new
    redirect_to root_url, notice: 'You are already signed in.' if authenticated?
  end

  def create
    user = User.new(user_params)
    if user.save
      start_new_session_for user
      redirect_to after_authentication_url, notice: 'Signed up.'
    else
      redirect_to new_registration_url(email_address: params[:email_address]),
        alert: user.errors.full_messages.to_sentence
    end
  end

  private

  def user_params
    params.permit(:email_address, :password)
  end
end
