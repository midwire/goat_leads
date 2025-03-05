# frozen_string_literal: true

class UserDatatable < ApplicationDatatable

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: 'User.id', cond: :eq },
      email_address: { source: 'User.email_address', cond: :like }
    }
  end

  def data
    records.map do |record|
      user = record.decorate
      {
        id: user.id,
        email_address: user.email_address,
        DT_RowId: record.id
      }
    end
  end

  # rubocop:disable Naming/AccessorMethodName
  def get_raw_records
    User.unscoped
  end
  # rubocop:enable Naming/AccessorMethodName
end
