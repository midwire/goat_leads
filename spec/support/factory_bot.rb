# frozen_string_literal: true

require 'factory_bot'

module FactoryBot
  DEFAULT_TEST_PASSWORD = 'a12x3456/B$'
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
