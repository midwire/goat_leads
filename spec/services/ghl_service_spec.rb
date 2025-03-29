# frozen_string_literal: true

require 'rails_helper'
require_relative '../shared/faraday_service_spec'

RSpec.describe GhlService, type: :service do
  subject(:service) { described_class.new(auth_token) }

  # NOTE: These may need to be updated from time to time
  let(:auth_token) { Rails.application.credentials.ghl.test[:auth_token] }
  let(:refresh_token) { Rails.application.credentials.ghl.test[:refresh_token] }
  let(:location_id) { Rails.application.credentials.ghl.test[:location_id] }

  if ENV['INTEGRATION']
    # Create a real lead on GHL
    describe '#create_lead' do
      # let(:lead_order) { create(:lead_order, :veteran) }
      # let(:lead) { create(:veteran_lead_premium, lead_order: lead_order) }
      # let(:lead_order) { create(:lead_order, :fex) }
      # let(:lead) { create(:final_expense_lead_premium, lead_order: lead_order) }
      # let(:lead_order) { create(:lead_order, :iul) }
      # let(:lead) { create(:index_universal_life_lead_premium, lead_order: lead_order) }
      let(:lead_order) { create(:lead_order, :mp) }
      let(:lead) { create(:mortgage_protection_lead_premium, lead_order: lead_order) }

      before do
        # Wire up GHL credentials
        lead_order.user.update!(
          ghl_access_token: auth_token,
          ghl_refresh_token: refresh_token,
          ghl_location_id: location_id
        )
      end

      it 'returns a success response' do
        result = service.create_lead(lead.to_ghl_format)
        expect(result[:success]).to be(true)
      end
    end
  end
end
