# frozen_string_literal: true

class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  layout 'welcome'

  rate_limit to: 10, within: 3.minutes, only: %i[create new], with: lambda {
    redirect_to new_session_url, alert: 'Try again later.'
  }

  def new
    @user = User.new
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))
    if user
      if user.verified?
        start_new_session_for user
        redirect_to after_authentication_url
      else
        redirect_to new_session_path, alert: 'Invalid email address or password.'
      end
    else
      redirect_to new_session_path, alert: 'Invalid email address or password.'
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
