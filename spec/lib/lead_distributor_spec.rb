# frozen_string_literal: true

require 'rails_helper'

# spec/services/lead_distributor_spec.rb
# frozen_string_literal: true

RSpec.describe LeadDistributor, type: :service do
  let(:lead) { double('Lead', id: 123, lead_order: lead_order, sms_message: 'Test SMS message') }
  let(:lead_order) do
    double('LeadOrder',
      ringy_enabled?: ringy_enabled,
      webhook_enabled?: webhook_enabled,
      sms_enabled?: sms_enabled,
      email_enabled?: email_enabled,
      ringy_sid: 'sid123',
      ringy_auth_token: 'token123',
      webhook_url: 'https://webhook.example.com',
      agent_phone: '+19876543210')
  end
  let(:ringy_enabled) { false }
  let(:webhook_enabled) { false }
  let(:sms_enabled) { false }
  let(:email_enabled) { false }
  let(:ringy_service) { instance_double(RingyService) }
  let(:webhook_service) { instance_double(WebhookService) }
  let(:twilio_service) { instance_double(TwilioService) }
  let(:logger) { instance_double(ActiveSupport::Logger) }
  let(:slack_notifier) { instance_double(Slack::Notifier) }

  before do
    # Stub external dependencies
    allow(RingyService).to receive(:new).and_return(ringy_service)
    allow(WebhookService).to receive(:new).and_return(webhook_service)
    allow(TwilioService).to receive(:new).and_return(twilio_service)
    allow(EmailJob).to receive(:perform_async).and_return(nil)
    allow(Rails).to receive(:logger).and_return(logger)
    allow(logger).to receive(:info)
    allow(logger).to receive(:error)
    allow(lead).to receive_messages(to_ringy_format: { name: 'Test Lead' },
      to_webhook_format: { name: 'Test Lead' })
    allow(SlackPipe).to receive(:send_msg)
    allow(Slack::Notifier).to receive(:new).and_return(slack_notifier)
    allow(slack_notifier).to receive(:ping)
  end

  describe '.distribute_lead' do
    context 'when only Ringy is enabled' do
      let(:ringy_enabled) { true }
      let(:ringy_response) { { success: true, data: { vendorResponseId: 'abc123' } } }

      before do
        allow(ringy_service).to receive(:create_lead).and_return(ringy_response)
      end

      it 'sends the lead to Ringy and logs success' do
        described_class.distribute_lead(lead)
        expect(RingyService).to have_received(:new).with('sid123', 'token123')
        expect(ringy_service).to have_received(:create_lead).with({ name: 'Test Lead' })
        expect(logger).to have_received(:info).with("Lead 123 successfully sent to Ringy: #{ringy_response[:data]}")
        expect(SlackPipe).not_to have_received(:send_msg)
      end

      context 'when Ringy fails' do
        let(:ringy_response) { { success: false, error: 'Invalid data' } }

        it 'logs the failure and sends to Slack' do
          described_class.distribute_lead(lead)
          expect(ringy_service).to have_received(:create_lead)
          expect(logger).to have_received(:error).with('Failed to send lead 123 to Ringy: Invalid data')
          expect(SlackPipe).to have_received(:send_msg).with('Failed to send lead 123 to Ringy: Invalid data')
        end
      end
    end

    context 'when only Webhook is enabled' do
      let(:webhook_enabled) { true }
      let(:webhook_response) { { success: true, data: { id: 'web123' } } }

      before do
        allow(webhook_service).to receive(:create_lead).and_return(webhook_response)
      end

      it 'sends the lead to Webhook and logs success' do
        described_class.distribute_lead(lead)
        expect(WebhookService).to have_received(:new).with('https://webhook.example.com')
        expect(webhook_service).to have_received(:create_lead).with({ name: 'Test Lead' })
        expect(logger).to have_received(:info).with("Lead 123 successfully sent to Webhook: #{webhook_response[:data]}")
        expect(SlackPipe).not_to have_received(:send_msg)
      end

      context 'when Webhook fails' do
        let(:webhook_response) { { success: false, error: 'Timeout' } }

        it 'logs the failure and sends to Slack' do
          described_class.distribute_lead(lead)
          expect(webhook_service).to have_received(:create_lead)
          expect(logger).to have_received(:error).with('Failed to send lead 123 to Webhook: Timeout')
          expect(SlackPipe).to have_received(:send_msg).with('Failed to send lead 123 to Webhook: Timeout')
        end
      end
    end

    context 'when only SMS is enabled' do
      let(:sms_enabled) { true }
      let(:twilio_response) { { success: true, message_sid: 'SM123456' } }

      before do
        allow(twilio_service).to receive(:send_sms).and_return(twilio_response)
      end

      it 'sends the SMS and does not log on success' do
        described_class.distribute_lead(lead)
        expect(TwilioService).to have_received(:new)
        expect(twilio_service).to have_received(:send_sms).with('+19876543210', 'Test SMS message')
        expect(logger).not_to have_received(:error)
        expect(SlackPipe).not_to have_received(:send_msg)
      end

      context 'when SMS fails' do
        let(:twilio_response) { { success: false, error: 'Invalid number' } }

        it 'logs the failure and sends to Slack' do
          described_class.distribute_lead(lead)
          expect(twilio_service).to have_received(:send_sms)
          expect(logger).to have_received(:error).with('TwilioService failed to send SMS for lead: 123, message: Invalid number')
          expect(SlackPipe).to have_received(:send_msg).with('TwilioService failed to send SMS for lead: 123, message: Invalid number')
        end
      end
    end

    context 'when only email is enabled' do
      let(:email_enabled) { true }
      let(:email_response) { {} }

      before do
        allow(EmailJob).to receive(:perform_async).and_return(email_response)
      end

      it 'sends the email and does not log on success' do
        described_class.distribute_lead(lead)
        expect(EmailJob).to have_received(:perform_async)
        expect(logger).not_to have_received(:error)
        expect(SlackPipe).not_to have_received(:send_msg)
      end
    end

    context 'when all services are enabled' do
      let(:ringy_enabled) { true }
      let(:webhook_enabled) { true }
      let(:sms_enabled) { true }
      let(:email_enabled) { true }
      let(:ringy_response) { { success: true, data: { vendorResponseId: 'abc123' } } }
      let(:webhook_response) { { success: true, data: { id: 'web123' } } }
      let(:twilio_response) { { success: true, message_sid: 'SM123456' } }
      let(:email_response) { {} }

      before do
        allow(ringy_service).to receive(:create_lead).and_return(ringy_response)
        allow(webhook_service).to receive(:create_lead).and_return(webhook_response)
        allow(twilio_service).to receive(:send_sms).and_return(twilio_response)
        allow(EmailJob).to receive(:perform_async).and_return(email_response)
      end

      it 'sends the lead to all enabled services' do
        described_class.distribute_lead(lead)
        expect(ringy_service).to have_received(:create_lead)
        expect(webhook_service).to have_received(:create_lead)
        expect(twilio_service).to have_received(:send_sms).with('+19876543210', 'Test SMS message')
        expect(EmailJob).to have_received(:perform_async)
        expect(logger).to have_received(:info).exactly(3).times # For Ringy and Webhook success
        expect(logger).not_to have_received(:error)
      end
    end

    context 'when no services are enabled' do
      it 'does not call any services' do
        described_class.distribute_lead(lead)
        expect(RingyService).not_to have_received(:new)
        expect(WebhookService).not_to have_received(:new)
        expect(TwilioService).not_to have_received(:new)
        expect(EmailJob).not_to have_received(:perform_async)
        expect(logger).not_to have_received(:info)
        expect(logger).not_to have_received(:error)
        expect(SlackPipe).not_to have_received(:send_msg)
      end
    end
  end
end
