# frozen_string_literal: true

class EmailVerificationsController < ApplicationController
  allow_unauthenticated_access

  rate_limit to: 10, within: 3.minutes, only: :create, with: lambda {
    redirect_to new_session_url, alert: 'Try again later.'
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

  def resend
  end
end
