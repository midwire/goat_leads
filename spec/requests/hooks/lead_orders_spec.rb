# frozen_string_literal: true

require 'rails_helper'

module Hooks
  RSpec.describe 'LeadOrders', type: :request do
    let(:url) { '/hooks/lead_orders' }
    let(:valid_params) do
      param_fixture(:veteran_lead_order_standard)
    end

    describe 'Lead Orders' do
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
    end

  end
end
