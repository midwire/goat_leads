# frozen_string_literal: true

class LeadSheetWriter
  def initialize(service = GoogleSheetsService.new)
    @sheets_service = service
  end

  def distribute_lead(url, lead, sheet_name = 'Sheet1')
    sheets_service.append_to_next_row(url, lead.to_array, sheet_name)
  rescue StandardError => e
    Rails.logger.error(">>> Failed to write lead to Google Sheet: #{e.message}")
    raise
  end

  private

  attr_reader :sheets_service
end
