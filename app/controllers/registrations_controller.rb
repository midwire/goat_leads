# frozen_string_literal: true

class RegistrationsController < ApplicationController
  include VerifyRecaptcha

  allow_unauthenticated_access only: %i[new create]

  layout 'welcome'

  wrap_parameters :user, include: User.attribute_names + %i[password password_confirmation]
  rate_limit to: 10, within: 3.minutes, with: lambda {
    redirect_to new_session_url, alert: 'Try again later.'
  }

  # GET /registration/new
  def new
    redirect_to root_url, notice: 'You are already signed in.' if authenticated?
    @user = User.new
  end

  # POST /registration
  def create
    user = User.new(user_params)
    if verify_recaptcha(recaptcha_param, 'signup')
      if user.save
        UserMailer.verify_email(user.id).deliver_now
        redirect_to new_session_url, notice: 'Check your email for verification instructions.'
      else
        redirect_to new_registration_url,
          alert: user.errors.full_messages.to_sentence
      end
    else
      redirect_to new_registration_url, alert: 'reCAPTCHA verification failed. Are you a bot?'
    end
  end

  private

  def user_params
    params.expect(user: %i[email_address password password_confirmation])
  end

  def recaptcha_param
    params.expect(user: %i[recaptcha_token])[:recaptcha_token]
  end
end
