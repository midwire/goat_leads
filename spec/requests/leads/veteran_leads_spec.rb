# frozen_string_literal: true

require 'rails_helper'

module Leads
  RSpec.describe 'VeteranLeads', type: :request do
    describe 'POST /leads/veteran_lead' do
      let(:params) do
        param_fixture(:veteran_lead)
      end

      it 'returns a created response' do
        post '/leads/veteran_lead', params: params
        expect(response).to have_http_status(:created)
      end

      it 'creates a lead' do
        expect do
          post '/leads/veteran_lead', params: params
        end.to change(Lead, :count).by(1)
      end
    end
  end
end
