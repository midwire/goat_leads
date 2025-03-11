# frozen_string_literal: true

require 'rails_helper'

require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe AssignLeadsJob, type: :job do
  let(:leads) { create_list(:veteran_lead_premium, 2) }

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

  context 'when Sidekiq::Testing.disabled?' do
    before do
      Sidekiq::Testing.disable!
      Sidekiq.redis(&:flushdb)
    end

    after do
      Sidekiq.redis(&:flushdb)
    end

    it 'prevents duplicate jobs from being scheduled' do
      SidekiqUniqueJobs.use_config(enabled: true) do
        expect(described_class.perform_in(3600)).not_to be_nil
        expect(described_class.perform_async).to be_nil
      end
    end
  end
end
