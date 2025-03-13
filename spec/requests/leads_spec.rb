# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Leads', type: :request do
  let(:valid_attributes) do
    build(:veteran_lead_premium).attributes.with_indifferent_access
  end

  let(:invalid_attributes) do
    valid_attributes.merge(state: nil)
  end

  let(:lead) { create(:veteran_lead_premium) }
  let(:user) { create(:user) }

  before { login_user(user) }

  describe 'GET /index' do
    it 'renders a successful response' do
      expect(lead).to be_present
      get leads_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get lead_url(lead)
      expect(response).to be_successful
    end
  end

  describe 'DELETE /destroy' do
    # NOTE: Not currently allowed
    # it 'destroys the requested lead' do
    #   expect do
    #     delete lead_url(lead)
    #   end.to change(LeadOrder, :count).by(-1)
    # end

    it 'destroys the requested lead' do
      expect do
        delete lead_url(lead)
      end.not_to change(LeadOrder, :count)
    end

    it 'redirects to the leads list' do
      delete lead_url(lead)
      expect(response).to redirect_to(leads_url)
    end
  end
end
