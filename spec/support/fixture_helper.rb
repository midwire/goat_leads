# frozen_string_literal: true

module FixtureHelper
  def param_fixture(fixture_name)
    path = File.join("spec/fixtures/#{fixture_name}.json")
    json = File.read(path)
    JSON.parse(json).with_indifferent_access
  end
end

RSpec.configure do |config|
  config.include FixtureHelper
end
