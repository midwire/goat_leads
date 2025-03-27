# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'
require_relative '../shared/faraday_service_spec'

RSpec.describe WebhookService, type: :service do
  subject(:service) { described_class.new(webhook_url) }

  let(:webhook_url) { 'https://google.com' }
  let(:lead_data) do
    lead = create(:veteran_lead_premium)
    lead.to_ringy_format
  end
  let(:headers) do
    {
      'Content-Type' => 'application/json'
    }
  end
  # For shared examples
  let(:service_args) { [webhook_url] }
  let(:base_url) { nil }

  before do
    # Stub all HTTP requests
    WebMock.enable!
  end

  after do
    WebMock.disable!
  end

  it_behaves_like 'a Faraday service'

  describe '#initialize' do
    context 'when webhook_url is missing' do
      let(:webhook_url) { nil }

      it 'raises an argument error' do
        expect { service }.to raise_error(ArgumentError, /missing webhook url/i)
      end
    end
  end

  describe '.create_lead' do
    context 'when the request is successful' do
      let(:response_body) { { 'vendorResponseId' => 'o4sniok8', 'status' => 'created' } }

      before do
        stub_request(:post, webhook_url)
            .with(headers: headers, body: lead_data.to_json)
            .to_return('status': 201, body: response_body.to_json, headers: headers)
      end

      it 'returns a success response with the lead data' do
        result = service.create_lead(lead_data)
        expect(result).to eq(success: true, data: response_body)
      end
    end

    context 'when the request fails with a client error' do
      let(:error_body) { { 'error' => 'Invalid lead data' } }

      before do
        stub_request(:post, webhook_url)
            .with(headers: headers, body: lead_data.to_json)
            .to_return(status: 400, body: error_body.to_json, headers: headers)
      end

      it 'returns a failure response with the error details' do
        result = service.create_lead(lead_data)
        expect(result).to eq(success: false, error: '>>> Client error: 400', details: error_body)
      end
    end

    context 'when the request fails with a server error' do
      before do
        stub_request(:post, webhook_url)
            .with(headers: headers, body: lead_data.to_json)
            .to_return(status: 500, body: '', headers: headers)
      end

      it 'returns a failure response with a generic error' do
        result = service.create_lead(lead_data)
        expect(result[:success]).to be(false)
        expect(result[:error]).to be_present
      end
    end

    context 'when lead_data is invalid' do
      let(:invalid_lead_data) { lead_data.merge(first_name: nil) } # Assuming this is invalid per Ringy API

      before do
        stub_request(:post, webhook_url)
            .with(headers: headers, body: invalid_lead_data.to_json)
            .to_return(status: 400, body: { 'error' => 'Missing required fields' }.to_json, headers: headers)
      end

      it 'returns a failure response' do
        result = service.create_lead(invalid_lead_data)
        expect(result[:success]).to be(false)
      end
    end
  end

  if ENV['INTEGRATION']
    # Create a real lead on Ringy
    # This may go away when the trial account goes away
    describe '#create_lead' do
      context 'when request is successful' do
        it 'returns a success response' do
          result = service.create_lead(lead_data)
          expect(result[:success]).to be(true)
        end
      end
    end
  end
end
