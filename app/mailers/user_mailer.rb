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

  def new_lead(lead_id)
    @lead = Lead.find(lead_id).decorate
    return nil unless @lead.delivered?

    @lead_order = @lead.lead_order.decorate
    if @lead_order.blank?
      msg = "Lead order is missing for: #{@lead.id}. Can't send new_lead email."
      Rails.logger.error(msg)
      SlackPipe.send_msg(msg)
      return nil
    end
    @user = @lead.user
    mail(to: @lead_order.agent_email, subject: "New #{@lead.display_type} - #{@lead.display_name}")
  end
end
