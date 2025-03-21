# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting...
  # webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :prepare_exception_notifier

  private

  # array_value = if parms[attribute].respond_to?(:map) ? parms[attribute] : parms[attribute].split(/,\w*/)
  # Normalize array params for postgres array columns
  # Make sure to expect the params like this:
  # params.expect(model: [:some_param, {some_array_param: []}])
  def normalize_array_param(parms, attribute)
    value = parms[attribute]
    return [] if value.blank?

    Array(value).flat_map do |item|
      item.to_s.split(/\s*,\s*/)
    end.map(&:strip).reject(&:empty?)
  end

  def prepare_exception_notifier
    request.env['exception_notifier.exception_data'] = {
      current_user: "User ID: #{@current_user&.id}, EMAIL: #{@current_user&.email_address}"
    }
  end
end
