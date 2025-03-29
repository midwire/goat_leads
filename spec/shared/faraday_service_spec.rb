# frozen_string_literal: true

require 'rails_helper'

unless defined?(FaradayServiceSharedExamples)
  module FaradayServiceSharedExamples; end

  RSpec.shared_context 'a Faraday service' do
    let(:service) { described_class.new(*service_args) }
    let(:response) { instance_double(Faraday::Response, status: 200, body: { id: 123 }) }

    describe '#build_connection' do
      it 'configures Faraday with the correct middleware' do
        connection = service.send(:build_connection, base_url: base_url, form_url_encode: form_url_encode)
        expect(connection.builder.handlers).to include(Faraday::Response::Json)
        expect(connection.builder.handlers).to include(Faraday::Retry::Middleware)
        expect(connection.url_prefix.to_s).to eq(base_url.to_s) if base_url
      end
    end

    describe '#handle_response' do
      context 'when the response is successful (200-201)' do
        let(:response) { instance_double(Faraday::Response, status: 201, body: { id: 123 }) }

        it 'returns a success response' do
          result = service.send(:handle_response, response)
          expect(result).to eq(success: true, data: { id: 123 })
        end
      end

      context 'when the response is a 401 Unauthorized error' do
        let(:response) { instance_double(Faraday::Response, status: 401, body: { error: 'Unauthorized' }) }

        it 'returns an unauthorized error' do
          result = service.send(:handle_response, response)
          expect(result).to eq(success: false, error: service.send(:unauthorized_error_message))
        end
      end

      context 'when the response is a 400 client error' do
        let(:response) { instance_double(Faraday::Response, status: 400, body: { error: 'Invalid data' }) }

        it 'returns a client error with details' do
          result = service.send(:handle_response, response)
          expect(result).to eq(
            success: false,
            error: 'Client error: 400',
            details: { error: 'Invalid data' }
          )
        end
      end

      context 'when the response is a 500 server error' do
        let(:response) { instance_double(Faraday::Response, status: 500, body: '') }

        it 'returns a server error' do
          result = service.send(:handle_response, response)
          expect(result).to eq(success: false, error: 'Server error: 500')
        end
      end

      context 'when the response is an unexpected status code' do
        let(:response) { instance_double(Faraday::Response, status: 301, body: '') }

        it 'returns an unexpected response error' do
          result = service.send(:handle_response, response)
          expect(result).to eq(success: false, error: 'Unexpected response: 301')
        end
      end
    end
  end
end
