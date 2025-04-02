# frozen_string_literal: true

module VerifyRecaptcha
  extend ActiveSupport::Concern

  private

  def verify_recaptcha(token, action, minimum_score = 0.5)
    uri = URI.parse('https://www.google.com/recaptcha/api/siteverify')
    response = Net::HTTP.post_form(uri, {
      'secret' => Rails.application.credentials.recaptcha[:secret_key],
      'response' => token
    })
    result = JSON.parse(response.body)
    result['success'] && result['score'] >= minimum_score && result['action'] == action
  rescue StandardError => e
    Rails.logger.error "reCAPTCHA verification failed: #{e.message}"
    false
  end
end
