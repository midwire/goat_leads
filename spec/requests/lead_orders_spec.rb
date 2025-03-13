# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/lead_orders', type: :request do

  # This should return the minimal set of attributes required to create a valid
  # LeadOrder. As you add validations to LeadOrder, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attr = build(:lead_order).attributes.with_indifferent_access
    attr.merge(user_id: user.id)
  end

  let(:invalid_attributes) do
    valid_attributes.merge(states: nil)
  end

  let(:lead_order) { create(:lead_order, :with_user) }
  let(:user) { lead_order.user }

  before { login_user(user) }

  describe 'GET /index' do
    it 'renders a successful response' do
      expect(lead_order).to be_present
      get lead_orders_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get lead_order_url(lead_order)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_lead_order_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_lead_order_url(lead_order)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new LeadOrder' do
        expect do
          post lead_orders_url, params: { lead_order: valid_attributes }
        end.to change(LeadOrder, :count).by(1)
      end

      it 'redirects to the lead_orders list' do
        post lead_orders_url, params: { lead_order: valid_attributes }
        expect(response).to redirect_to(lead_orders_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new LeadOrder' do
        expect do
          post lead_orders_url, params: { lead_order: invalid_attributes }
        end.not_to change(LeadOrder, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post lead_orders_url, params: { lead_order: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        attr = valid_attributes
        attr.merge(states: %w[id])
      end

      it 'updates the requested lead_order' do
        patch lead_order_url(lead_order), params: { lead_order: new_attributes }
        lead_order.reload
        expect(lead_order.states).to eq(%w[ID])
      end

      it 'redirects to the lead_orders list' do
        patch lead_order_url(lead_order), params: { lead_order: new_attributes }
        lead_order.reload
        expect(response).to redirect_to(lead_orders_url)
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch lead_order_url(lead_order), params: { lead_order: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested lead_order' do
      expect do
        delete lead_order_url(lead_order)
      end.to change(LeadOrder, :count).by(-1)
    end

    it 'redirects to the lead_orders list' do
      delete lead_order_url(lead_order)
      expect(response).to redirect_to(lead_orders_url)
    end
  end
end
