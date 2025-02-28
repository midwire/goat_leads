# frozen_string_literal: true

class LeadDatatable < ApplicationDatatable

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= begin
      cols = {}
      Class.new.extend(CsvConfig).agent_visible_columns_hash.each do |colname, data|
        next unless data[:agent_visible]

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
    hash = Class.new.extend(CsvConfig).agent_visible_columns_hash.symbolize_keys
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

  def get_raw_records
    Lead.unscoped.includes(:user).all
  end

  private

  def format_value(key, value, record)
    return value unless key == :address

    url = lead_path(record)
    buttoned(url, value)
  end

  def user
    @user ||= options[:user]
  end
end
