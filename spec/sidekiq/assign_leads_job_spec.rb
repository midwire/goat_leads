# frozen_string_literal: true

require 'rails_helper'

require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe AssignLeadsJob, type: :job do
  let(:leads) { create_list(:veteran_lead, 2) }

  after do
    described_class.clear # Clear the queue
  end

  it 'queues the job' do
    expect(leads).to be_present
    expect do
      described_class.perform_async
    end.to change(described_class.jobs, :size).by(1)
  end

  it 'performs' do
    described_class.perform_async
    expect do
      described_class.drain
    end.not_to raise_error
  end
end
