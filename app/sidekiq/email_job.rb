# frozen_string_literal: true

class EmailJob
  include Sidekiq::Job
  sidekiq_options queue: :mailer

  def perform(mailer_class, mailer_action, *args)
    mailer = mailer_class.constantize
    mailer.send(mailer_action, *args).deliver_now
  rescue StandardError => e
    Rails.logger.error { "Failed to send email: #{e.message}" }
    raise e
  end
end
