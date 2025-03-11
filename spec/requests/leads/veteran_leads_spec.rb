# frozen_string_literal: true

require 'rails_helper'

module Leads
  RSpec.describe 'VeteranLeads', type: :request do
    describe 'POST /leads/veteran_lead' do
      context 'without lead_quality or video_type' do
        let(:params) do
          param_fixture(:veteran_lead)
        end

        it 'returns a created response' do
          post '/leads/veteran_lead', params: params
          expect(response).to have_http_status(:created)
        end

        it 'creates a VeteranLeadPremium lead' do
          expect do
            post '/leads/veteran_lead', params: params
          end.to change(VeteranLeadPremium, :count).by(1)
          expect(VeteranLeadPremium.last.video_type).to eq('Other')
        end
      end

      context 'with lead_quality' do
        let(:params) do
          param_fixture(:veteran_lead_standard)
        end

        it 'returns a created response' do
          post '/leads/veteran_lead', params: params
          expect(response).to have_http_status(:created)
        end

        it 'creates a VeteranLeadStandard lead' do
          expect do
            post '/leads/veteran_lead', params: params
          end.to change(VeteranLeadStandard, :count).by(1)
          expect(VeteranLeadStandard.last.video_type).to eq('Dom')
        end
      end
    end
  end
end
