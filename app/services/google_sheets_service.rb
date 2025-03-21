# frozen_string_literal: true

require 'google/apis/sheets_v4'
require 'google/apis/drive_v3'
require 'googleauth'

class GoogleSheetsService
  # Full access to Sheets and Drive
  SCOPE = 'https://www.googleapis.com/auth/spreadsheets https://www.googleapis.com/auth/drive'

  def initialize
    @sheets_service = Google::Apis::SheetsV4::SheetsService.new
    @drive_service = Google::Apis::DriveV3::DriveService.new
    credentials = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(Rails.application.credentials.google_sheets[:service_account]),
      scope: SCOPE
    )
    @sheets_service.authorization = credentials
    @drive_service.authorization = credentials
  end

  ########################################
  # Read-Write Values

  # Read spreadsheet values
  def get_values(spreadsheet_id, range)
    with_error_handling do
      @sheets_service.get_spreadsheet_values(spreadsheet_id, range).values
    end
  end

  # Write spreadsheet values
  def update_values(spreadsheet_id, range, values)
    with_error_handling do
      value_range = Google::Apis::SheetsV4::ValueRange.new(values: values)
      @sheets_service.update_spreadsheet_value(
        spreadsheet_id,
        range,
        value_range,
        value_input_option: 'RAW'
      )
    end
  end

  # Append data to the first blank row
  def append_to_next_row(url, values, sheet_name = 'Sheet1', start_column = 'A')
    with_error_handling do
      spreadsheet = get_spreadsheet_by_url(url)
      spreadsheet_id = spreadsheet.spreadsheet_id
      range = "#{sheet_name}!#{start_column}:#{start_column}" # e.g., "Sheet1!A:A"
      value_range = Google::Apis::SheetsV4::ValueRange.new(values: [values]) # Wrap in array for single row
      @sheets_service.append_spreadsheet_value(
        spreadsheet_id,
        range,
        value_range,
        value_input_option: 'RAW'
      )
      spreadsheet # Return the spreadsheet instance for chaining if needed
    end
  end

  ########################################
  # Spreadsheet methods

  # Find spreadsheet
  def find_spreadsheet_by_name(name)
    # Search for spreadsheets by name, restricting to Google Sheets MIME type
    with_error_handling do
      Rails.logger.debug "Searching for spreadsheet with name: '#{name}'"
      sanitized_name = name.to_s.strip.gsub(/['"]/, '') # Remove quotes to avoid query issues
      query = %(name='#{sanitized_name}' and mimeType='application/vnd.google-apps.spreadsheet')

      response = @drive_service.list_files(
        q: query,
        fields: 'files(id, name, web_view_link)'
      )
      response.files # Returns an array of matching files
    end
  end

  # Find spreadsheet
  def get_spreadsheet_by_url(url)
    with_error_handling do
      spreadsheet_id = extract_spreadsheet_id(url)
      Rails.logger.debug "Fetching spreadsheet with ID: #{spreadsheet_id}"
      @sheets_service.get_spreadsheet(spreadsheet_id)
    end
  end

  # Create new spreadsheet
  def create_spreadsheet(title = 'New Spreadsheet')
    with_error_handling do
      spreadsheet = Google::Apis::SheetsV4::Spreadsheet.new(
        properties: Google::Apis::SheetsV4::SpreadsheetProperties.new(title: title),
        sheets: [Google::Apis::SheetsV4::Sheet.new(properties: { title: 'Sheet1' })]
      )
      @sheets_service.create_spreadsheet(spreadsheet)
    end
  end

  # Delete spreadsheet
  def delete_spreadsheet(spreadsheet_id)
    with_error_handling do
      @drive_service.delete_file(spreadsheet_id)
    end
  end

  # Share spreadsheet
  def share_spreadsheet(spreadsheet_id, email, role = 'writer')
    with_error_handling do
      permission = Google::Apis::DriveV3::Permission.new(
        type: 'user',
        role: role, # "reader", "writer", or "owner"
        email_address: email
      )
      @drive_service.create_permission(spreadsheet_id, permission)
    end
  end

  private

  def extract_spreadsheet_id(url)
    uri = URI.parse(url)
    path_segments = uri.path.split('/')
    spreadsheet_id_index = path_segments.index('d') + 1
    path_segments[spreadsheet_id_index] || fail(ArgumentError, "Invalid Google Spreadsheet URL: #{url}")
  rescue URI::InvalidURIError
    raise ArgumentError, "Invalid URL format: #{url}"
  end

  # Common error handler
  def with_error_handling
    yield
  rescue Google::Apis::AuthorizationError => e
    Rails.logger.error "Authorization Error: #{e.message} (Status: #{e.status_code})"
    raise
  rescue Google::Apis::ClientError => e
    Rails.logger.error "Client Error: #{e.message} (Status: #{e.status_code})"
    raise
  rescue StandardError => e
    Rails.logger.error "Unexpected error in find_spreadsheet_by_name: #{e.inspect}"
    raise
  end
end
