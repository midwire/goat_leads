# frozen_string_literal: true

class LeadDatatable < ApplicationDatatable
  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= begin
      cols = {}
      columns_hash.each do |colname, data|
        cols[colname.to_sym] = {
          source: data[:source],
          cond: data[:cond],
          sortable: data[:sortable],
          searchable: data[:searchable]
        }
      end
      cols
    end
  end

  def data
    hash = columns_hash.symbolize_keys
    records.map do |record|
      lead = record.decorate
      data = {}
      hash.each do |key, val|
        data[key] = format_value(key, lead.send(val[:method]), record)
      end
      data[:DT_RowID] = record.id
      data
    end
  end

  # rubocop:disable Naming/AccessorMethodName
  def get_raw_records
    if user.admin?
      Lead.left_outer_joins(:lead_order)
          .includes(:lead_order)
    else
      user.leads
    end
  end
  # rubocop:enable Naming/AccessorMethodName

  private

  def format_value(key, value, record)
    special_keys = %i[full_name email phone]
    return value unless special_keys.include?(key)

    case key
    when :full_name
      path = edit_lead_path(record)
      circle = linked(path, user_initial_circle(value))
      name = linked(path, value)
      "#{circle} #{name}".html_safe
    when :phone
      linked("tel:#{value}", value)
    when :email
      linked("mailto:#{value}", value)
    when :type
      buttoned(lead_path(record), value)
    else
      value
    end
  end

  def user
    @user ||= options[:user]
  end

  def columns_hash
    return Class.new.extend(CsvConfig).admin_visible_columns_hash if user&.admin?

    Class.new.extend(CsvConfig).agent_visible_columns_hash
  end
end
