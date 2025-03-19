# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadParser, type: :lib do
  subject(:lead_parser) { described_class.new(valid_params) }

  let(:valid_params) do
    params = param_fixture(:veteran_lead_premium)
    ActionController::Parameters.new(params)[:form]
  end

  describe '.model_instance' do
    it 'returns the expected model instance' do
      expect(lead_parser.model_instance).to be_a(VeteranLeadPremium)
    end
  end
end
