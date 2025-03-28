# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe TwilioService, type: :service do
  subject(:service) { described_class.new }

  let(:to_number) { Rails.application.credentials.twilio[:to_test_number] }
  let(:message_body) { 'Test message from crm.goatleads.com' }
  let(:account_sid) { Rails.application.credentials.twilio[:account_sid] }
  let(:auth_token) { Rails.application.credentials.twilio[:auth_token] }
  let(:from_number) { Rails.application.credentials.twilio[:phone_number] }
  let(:twilio_url) { "https://api.twilio.com/2010-04-01/Accounts/#{account_sid}/Messages.json" }

  if ENV['INTEGRATION']
    describe '.send_sms - real_request', :real_request do
      before { WebMock.disable! }
      after { WebMock.enable! }

      it 'returns a success response with message SID' do
        result = service.send_sms(to_number, message_body)
        expect(result[:success]).to be(true)
      end
    end
  end

  before { WebMock.enable! }
  after { WebMock.disable! }

  describe '#send_sms' do
    context 'when the SMS is sent successfully' do
      before do
        stub_request(:post, twilio_url)
            .with(
              body: { 'Body' => message_body, 'From' => from_number, 'To' => to_number }
            )
            .to_return(
              status: 201,
              body: { sid: 'SM123456789', status: 'queued' }.to_json,
              headers: { 'Content-Type' => 'application/json' }
            )
      end

      it 'returns a success response with message SID' do
        result = service.send_sms(to_number, message_body)
        expect(result[:success]).to be(true)
        expect(result[:message_sid]).to eq('SM123456789')
      end
    end

    context 'when the SMS fails' do
      before do
        stub_request(:post, twilio_url)
            .with(
              body: { 'Body' => message_body, 'From' => from_number, 'To' => to_number }
            )
            .to_return(status: 400, body: { code: 21211, message: 'Invalid phone number' }.to_json)
      end

      it 'returns a failure response with error details' do
        result = service.send_sms(to_number, message_body)
        expect(result[:success]).to be(false)
        expect(result[:error]).to include('Invalid phone number')
      end
    end
  end

  describe '#valid_phone_number?' do
    it 'returns true for a valid E.164 number' do
      expect(service.valid_phone_number?('+12345678901')).to be(true)
    end

    it 'returns false for an invalid number' do
      expect(service.valid_phone_number?('123-456-7890')).to be(false)
    end
  end
end
