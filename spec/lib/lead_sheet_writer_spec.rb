# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadSheetWriter, type: :lib do
  subject(:writer) { described_class.new }

  let(:sheet_url) do
    'https://docs.google.com/spreadsheets/d/17Q3XFm27bFzSZJd6Tvj2-kRB1CSYZT2K7BKLGHRPQ14/edit'
  end
  let(:lead) { create(:veteran_lead_premium) }

  describe 'distribute_lead' do
    it 'writes a lead to the spreadsheet' do
      expect do
        writer.distribute_lead(sheet_url, lead)
      end.not_to raise_error
    end
  end
end
