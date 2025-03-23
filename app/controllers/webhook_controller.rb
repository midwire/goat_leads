# frozen_string_literal: true

class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access
end
