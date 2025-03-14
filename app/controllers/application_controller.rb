# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting...
  # webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :prepare_exception_notifier

  private

  # Normalize array params for postgres array columns
  # Make sure to expect the params like this:
  # params.expect(model: [:some_param, {some_array_param: []}])
  def normalize_array_param(parms, attribute)
    return [] if parms[attribute].blank?

    p = parms[attribute].map { |e| e.split(',') }.flatten
    p.map!(&:strip)
    p.reject!(&:empty?)
    p
  end

  def prepare_exception_notifier
    request.env['exception_notifier.exception_data'] = {
      current_user: "User ID: #{@current_user&.id}, EMAIL: #{@current_user.email_address}"
    }
  end
end
