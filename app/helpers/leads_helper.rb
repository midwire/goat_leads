# frozen_string_literal: true

module LeadsHelper
  def lead_card_body_data
    visible_lead_data
  end

  private

  def hidden_card_columns
    %w[type first_name last_name phone email]
  end

  def visible_lead_data
    data = user_approrpriate_columns
    data.reject do |col, _data|
      hidden_card_columns.include?(col)
    end
  end

  def user_approrpriate_columns
    return Class.new.extend(CsvConfig).agent_visible_columns_hash if @current_user&.agent?

    Class.new.extend(CsvConfig).admin_visible_columns_hash
  end
end
