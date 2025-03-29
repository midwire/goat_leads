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
      # Login successful - store GHL integration if appropriate
      persist_ghl_integration(user)
      if user.verified?
        start_new_session_for user
        redirect_to after_authentication_url
      else
        redirect_to new_session_path, alert: 'You have not verified your email address.'
      end
    else
      redirect_to new_session_path, alert: 'Invalid email address or password.'
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  private

  def persist_ghl_integration(user)
    # Store GHL integration data if necessary
    json = session[:ghl]
    return if json.blank?

    # Store access_token
    data = JSON.parse(ghl_json)

    ghl_data = ghl_attributes(data)
    user.update!(ghl_data) if ghl_data.any?

    # Delete cookie
    session.delete(:ghl)
  end

  def ghl_attributes(data)
    {
      ghl_company_id: data['company_id'],
      ghl_location_id: data['location_id'],
      ghl_access_token: data['access_token'],
      ghl_refresh_token: data['refresh_token'],
      ghl_refresh_date: data['refresh_token'].present? ? Date.current : nil
    }
  end
end
