# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'info@goatleadscom'
  layout 'mailer'
end
