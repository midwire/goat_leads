# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  include ApplicationHelper

  before_action :set_common_vars

  default from: 'leadsupport@goatleads.com'
  layout 'mailer'

  protected

  def set_common_vars
    @app_title = site_title
  end
end
