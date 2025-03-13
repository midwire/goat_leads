# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer do
  describe 'newsletter_confirmation' do
    let(:user) { create(:user) }
    let(:mail) { described_class.verify_email(user.id) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Please verify your email')
      expect(mail.to).to eq([user.email_address])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Please verify your email')
    end

    it 'delivers message' do
      expect do
        mail.deliver_now
      end.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
