# frozen_string_literal: true

class UserDatatable < ApplicationDatatable

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: 'User.id', cond: :eq },
      first_name: { source: 'User.first_name', cond: :like },
      last_name: { source: 'User.last_name', cond: :like },
      email_address: { source: 'User.email_address', cond: :like },
      phone: { source: 'User.phone', cond: :like },
      role: { source: 'User.role', cond: :like },
      status: { source: 'User.status', cond: :like },
      last_activity: { source: 'Session.updated_at', cond: :like },
      last_lead_delivered_at: { source: 'User.last_lead_delivered_at', cond: :like },
      notes: { source: 'User.notes', cond: :like }
    }
  end

  def data
    records.map do |record|
      user = record.decorate
      {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email_address: linked(edit_admin_user_path(record), user.email_address),
        phone: user.phone,
        notes: user.notes,
        status: user.status,
        role: user.role,
        last_lead_delivered_at: user.last_lead_delivered_at,
        last_activity: user.last_activity,
        DT_RowId: record.id
      }
    end
  end

  # rubocop:disable Naming/AccessorMethodName
  def get_raw_records
    # This should always be a dataset for an Admin user
    # User.joins(:sessions).includes(:sessions)
    User.includes(:sessions)
  end
  # rubocop:enable Naming/AccessorMethodName
end
