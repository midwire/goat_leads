# frozen_string_literal: true

class WelcomeController < ApplicationController
  allow_unauthenticated_access

  layout 'welcome'

  def index
  end
end
