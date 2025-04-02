# frozen_string_literal: true

# app/services/lead_daily_summary_importer.rb
class LeadDailySummaryImporter
  def initialize(google_sheets_service, spreadsheet_id, sheet_id)
    @google_sheets_service = google_sheets_service
    @spreadsheet_id = spreadsheet_id
    @sheet_id = sheet_id
  end

  def import
    # Fetch data from Google Sheets
    data = fetch_spreadsheet_data

    # Process each row and create/update LeadDailySummary records
    ActiveRecord::Base.transaction do
      data.each do |row|
        date = Date.parse(row[:date]) # Assuming the spreadsheet has a "Date" column
        lead_type = row[:lead_type]   # Assuming the spreadsheet has a "Lead Type" column
        lead_count = row[:count].to_i # Assuming the spreadsheet has a "Count" column
        total_cost = row[:cost].to_d  # Assuming the spreadsheet has a "Cost" column

        # Find or initialize the LeadDailySummary record
        summary = LeadDailySummary.find_or_initialize_by(date: date, lead_type: lead_type)
        summary.lead_count = lead_count
        summary.total_cost = total_cost
        summary.save!
      end
    end
  rescue StandardError => e
    Rails.logger.error("Failed to import LeadDailySummary data: #{e.message}")
    raise
  end

  private

  def fetch_spreadsheet_data
    # Use GoogleSheetsService to fetch the data
    # This is a placeholder; adjust based on your GoogleSheetsService implementation
    @google_sheets_service.read_sheet(@spreadsheet_id, @sheet_id)
  end
end
