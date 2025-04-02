# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  let(:valid_attributes) do
    {
      email_address: Faker::Internet.email,
      password: 'asdfasdf',
      password_confirmation: 'asdfasdf',
      recaptcha_token: recaptcha_token
    }
  end
  let(:recaptcha_token) { 'bogus' }
  let(:invalid_attributes) do
    valid_attributes.merge(password_confirmation: 'bogus')
  end

  describe 'GET /registration/new' do
    it 'renders a successful response' do
      get new_registration_url
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    before do
      allow_any_instance_of(RegistrationsController).to receive(:verify_recaptcha).and_return(true)
    end

    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post registration_url, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the login page' do
        post registration_url, params: { user: valid_attributes }
        expect(response).to redirect_to(new_session_url)
      end

      context 'with invalid recaptcha_token' do
        before do
          allow_any_instance_of(RegistrationsController).to receive(:verify_recaptcha).and_return(false)
        end

        it 'spec_name' do
          post registration_url, params: { user: valid_attributes }
          expect(response).to redirect_to(new_registration_url)
          expect(flash[:alert]).to match(/reCAPTCHA verification failed/)
        end
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post registration_url, params: { user: invalid_attributes }
        end.not_to change(User, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post registration_url, params: { user: invalid_attributes }
        expect(response).to redirect_to(new_registration_url)
        # expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
