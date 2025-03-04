# frozen_string_literal: true

require 'rails_helper'

require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe EmailJob, type: :job do
  let(:user) { create(:user) }

  after do
    described_class.clear # Clear the queue
  end

  it 'queues the job' do
    expect(user).to be_present
    expect do
      described_class.perform_async('UserMailer', 'verify_email', user.id)
    end.to change(described_class.jobs, :size).by(1)
  end

  it 'delivers the email' do
    described_class.perform_async('UserMailer', 'verify_email', user.id)
    expect do
      described_class.drain
    end.not_to raise_error
  end
end
