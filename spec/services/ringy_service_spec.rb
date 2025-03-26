# frozen_string_literal: true

require 'rails_helper'

if ENV['INTEGRATION']
  RSpec.describe RingyService, type: :service do
    subject(:service) { described_class.new(ringy_sid, ringy_auth_token) }

    let(:ringy_sid) { Rails.application.credentials.ringy.sid }
    let(:ringy_auth_token) { Rails.application.credentials.ringy.auth_token }
    let(:lead_data) do
      lead = create(:veteran_lead_premium)
      lead.to_ringy_format
    end

    describe '#create_lead' do
      context 'when request is successful' do
        it 'returns a success response' do
          result = service.create_lead(lead_data)
          expect(result[:success]).to be(true)
        end
      end
    end
  end
end
