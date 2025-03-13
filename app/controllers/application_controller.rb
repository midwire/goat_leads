# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting...
  # webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  # Normalize array params for postgres array columns
  # Make sure to expect the params like this:
  # params.expect(model: [:some_param, {some_array_param: []}])
  def normalize_array_param(parms, attribute)
    p = parms[attribute].map { |e| e.split(',') }.flatten
    p.map!(&:strip)
    p.reject!(&:empty?)
    p
  end
end
