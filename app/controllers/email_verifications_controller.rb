# frozen_string_literal: true

class EmailVerificationsController < ApplicationController
  allow_unauthenticated_access

  layout 'welcome'

  rate_limit to: 10, within: 3.minutes, with: lambda {
    redirect_to root_path, alert: 'Try again later.'
  }

  # rubocop:disable Rails/DynamicFindBy
  def show
    user = User.find_by_email_verification_token(params[:token])
    if user
      user.verify!
      redirect_to(new_session_path, notice: 'Your email has been verified.')
    else
      redirect_to(root_path, alert: 'The verification toke is invalid or has expired.')
    end
  end
  # rubocop:enable Rails/DynamicFindBy

  def new
  end

  def resend
    user = User.find_by(email_address: params.expect(:email_address))
    if user
      if user.verified?
        redirect_to new_session_url, notice: 'That email address is already verified.'
      else
        UserMailer.verify_email(user).deliver_later
        redirect_to new_session_url, notice: 'Check your email for verification instructions.'
      end
    else
      redirect_to(new_email_verification_path, notice: 'That email address is not found.')
    end
  end
end
