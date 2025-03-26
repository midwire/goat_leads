# frozen_string_literal: true

require 'rails_helper'

if ENV['INTEGRATION']
  RSpec.describe GoogleSheetsService, type: :service do
    subject(:service) { described_class.new }

    let(:sheet_id) do
      '17Q3XFm27bFzSZJd6Tvj2-kRB1CSYZT2K7BKLGHRPQ14'
    end
    let(:sheet_url) do
      'https://docs.google.com/spreadsheets/d/17Q3XFm27bFzSZJd6Tvj2-kRB1CSYZT2K7BKLGHRPQ14/edit'
    end
    let(:row_data) do
      lead = create(:veteran_lead_premium)
      lead.to_array
    end

    describe 'read and write values' do
      it 'reads and writes values' do
        range = 'Sheet1!A1'
        value = random_string(10)
        service.update_values(sheet_id, range, [[value]])
        val = service.get_values(sheet_id, range)
        expect([[value]]).to eq(val)
      end
    end

    describe 'append_to_next_row' do
      it 'appends data to the next blank row' do
        expect do
          service.append_to_next_row(sheet_url, row_data)
        end.not_to raise_error
      end
    end

    describe 'create_spreadsheet' do
      it 'creates and shares a new spreadsheet' do
        expect do
          sheet = service.create_spreadsheet('Goatleads Test Spreadsheet')
          service.share_spreadsheet(sheet.spreadsheet_id, 'cblackburn@goatleads.com')
        end.not_to raise_error
      end
    end

    describe 'find_spreadsheet_by_name' do
      it 'finds the named spreadsheet' do
        sheet = service.find_spreadsheet_by_name('Goatleads Test')
        expect(sheet.first).to be_a(Google::Apis::DriveV3::File)
      end
    end

    describe 'get_spreadsheet_by_url' do
      context 'with valid sheet url' do
        let(:url) { 'https://docs.google.com/spreadsheets/d/1iEQBViYSNDJ9pgUjXkPbt2kbtO08II2gQX3l1_ohr68/edit' }

        it 'returns an instance of spreadsheet' do
          expect(service.get_spreadsheet_by_url(url)).to be_a(Google::Apis::SheetsV4::Spreadsheet)
        end
      end

      context 'with invalid sheet url' do
        let(:url) { 'not a url' }

        it 'raises an error' do
          expect do
            service.get_spreadsheet_by_url(url)
          end.to raise_error(ArgumentError, /Invalid URL format/)
        end
      end

      context 'with unshared sheet url' do
        let(:url) { 'https://docs.google.com/spreadsheets/d/11CmtZIJU83Q4LRMML2K2Fo-l6-Rv2BFdfQApuzgfFDY/edit?gid=0#gid=0' }

        it 'raises an error' do
          expect do
            service.get_spreadsheet_by_url(url)
          end.to raise_error(Google::Apis::ClientError)
        end
      end
    end

    private

    def random_string(count)
      characters = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
      random_string = []
      count.times do
        random_string << characters.sample
      end
      random_string.join
    end
  end
end
