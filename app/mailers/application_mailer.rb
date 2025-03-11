# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'info@goatleads.com'
  layout 'mailer'
end
