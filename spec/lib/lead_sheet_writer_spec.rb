# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

if ENV['INTEGRATION']
  RSpec.describe LeadSheetWriter, type: :lib do
    subject(:writer) { described_class.new }

    let(:sheet_url) do
      'https://docs.google.com/spreadsheets/d/17Q3XFm27bFzSZJd6Tvj2-kRB1CSYZT2K7BKLGHRPQ14/edit'
    end
    let(:lead) { create(:veteran_lead_premium) }

    before do
      WebMock.allow_net_connect!
    end

    after do
      WebMock.reset!
    end

    describe 'distribute_lead' do
      # before do
      #   stub_request(:any, 'https://www.googleapis.com/oauth2/v4/token')
      # end

      it 'writes a lead to the spreadsheet' do
        expect do
          writer.distribute_lead(sheet_url, lead)
        end.not_to raise_error
      end
    end
  end
end
