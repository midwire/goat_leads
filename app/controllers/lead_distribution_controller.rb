# frozen_string_literal: true

class LeadDistributionController < ApplicationController
  before_action :set_lead
  before_action :set_service_method

  # GET /crm_send_lead/:service/:id
  def send_lead
    LeadDistributor.send(@service_method, @lead)
    redirect_to(edit_lead_path(@lead), info: "Lead sent to #{service_param}")
  end

  private

  def service_param
    params.expect(:service)
  end

  def set_lead
    @lead = Lead.find(params.expect(:id))
  end

  def set_service_method
    @service_method = case service_param.to_sym
    when :ringy
      'send_to_ringy'
    when :webhook
      'send_to_webhook'
    when :sms
      'send_to_sms'
    when :email
      'send_to_email'
    when :ghl
      'send_to_ghl'
    else
      fail(ArgumentError.new("Service: #{params[:service]} is not a valid external lead service."))
    end
  end
end
