# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'
require_relative '../shared/faraday_service_spec'

RSpec.describe GhlOauthService, type: :service do
  include FaradayService

  subject(:service) { described_class.new(client_id, client_secret, local_oauth_url) }

  let(:client_id) { Rails.application.credentials.ghl[:client_id] }
  let(:client_secret) { Rails.application.credentials.ghl[:client_secret] }
  let(:local_oauth_url) { 'http://test.host' }
  let(:code_param) { 'f7cb8a97c9d99ec7cbe065f91d27d84bd1d8b55d' }
  let(:headers) { { 'Accept' => 'application/json' } }
  let(:payload) do
    {
      client_id: client_id,
      client_secret: client_secret,
      grant_type: 'authorization_code',
      code: code_param,
      user_type: 'Location',
      redirect_uri: local_oauth_url
    }
  end
  # For shared examples
  let(:service_args) { [client_id, client_secret, local_oauth_url] }
  let(:base_url) { nil }
  let(:form_url_encode) { true }

  before do
    # Stub all HTTP requests
    WebMock.enable!
  end

  after do
    WebMock.disable!
  end

  it_behaves_like 'a Faraday service'

  describe '#initialize' do
    context 'when arguments are missing' do
      let(:client_id) { nil }

      it 'raises an argument error' do
        expect { service }.to raise_error(ArgumentError, /missing arguments/i)
      end
    end
  end

  describe '.post_oauth_request' do
    context 'when the request is successful' do
      let(:response_body) { { 'vendorResponseId' => 'o4sniok8', 'status' => 'created' } }

      before do
        stub_request(:post, described_class::TOKEN_URL)
            .with(headers: headers, body: payload)
            .to_return('status': 201, body: response_body.to_json, headers: headers)
      end

      it 'returns a success response with the lead data' do
        result = service.post_oauth_request(code_param)
        expect(result).to eq(success: true, data: response_body.to_json)
      end
    end
  end
end
