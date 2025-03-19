# frozen_string_literal: true

require 'rails_helper'

module Hooks
  RSpec.describe 'Leads', type: :request do

    describe 'Veteran Leads' do
      describe 'POST /hooks/leads' do
        context 'without lead_quality or video_type' do
          let(:params) do
            param_fixture(:veteran_lead_premium)
          end

          it 'returns a created response' do
            post '/hooks/leads', params: params
            expect(response).to have_http_status(:created)
          end

          it 'creates a VeteranLeadPremium lead' do
            expect do
              post '/hooks/leads', params: params
            end.to change(VeteranLeadPremium, :count).by(1)
            expect(VeteranLeadPremium.last.video_type).to eq('Other')
          end
        end

        context 'with lead_quality' do
          let(:params) do
            param_fixture(:veteran_lead_standard)
          end

          it 'returns a created response' do
            post '/hooks/leads', params: params
            expect(response).to have_http_status(:created)
          end

          it 'creates a VeteranLeadStandard lead' do
            expect do
              post '/hooks/leads', params: params
            end.to change(VeteranLeadStandard, :count).by(1)
            expect(VeteranLeadStandard.last.video_type).to eq('Dom')
          end
        end
      end
    end

  end
end
