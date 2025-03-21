# frozen_string_literal: true

require 'rails_helper'

module Hooks
  RSpec.describe 'LeadOrders', type: :request do
    let(:url) { '/hooks/lead_orders' }
    let(:lead_order) { create(:lead_order) }
    let(:valid_params) do
      param_fixture(:veteran_lead_order_standard)
    end
    let(:update_states_params) do
      {
        "data": {
          "states": 'wy, az'
        }
      }
    end

    describe 'POST /hooks/lead_orders' do
      it 'returns a created response' do
        post url, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'creates a veteran lead order standard' do
        expect do
          post url, params: valid_params
        end.to change(LeadOrder, :count).by(1)
        lo = LeadOrder.last
        expect(lo.lead_class).to eq('VeteranLeadStandard')
      end
    end

    # Update states
    describe 'PUT /hooks/lead_orders' do
      it 'returns a success response' do
        put hooks_lead_order_url(lead_order.order_id, format: :json), params: valid_params
        expect(response).to have_http_status(:ok)
      end

      it 'updates the states' do
        put hooks_lead_order_url(lead_order.order_id, format: :json), params: update_states_params
        lo = LeadOrder.last
        expect(lo.states).to eq(%w[WY AZ])
      end

    end

  end
end
