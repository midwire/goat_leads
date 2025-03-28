# frozen_string_literal: true

module LeadsHelper
  def lead_card_body_data(user)
    visible_lead_data(user)
  end

  private

  def hidden_card_columns
    %w[type first_name last_name phone email]
  end

  def visible_lead_data(user)
    data = user_approrpriate_columns(user)
    data.reject do |col, _data|
      hidden_card_columns.include?(col)
    end
  end

  def user_approrpriate_columns(user)
    return Class.new.extend(CsvConfig).agent_visible_columns_hash if user&.agent?

    Class.new.extend(CsvConfig).admin_visible_columns_hash
  end
end
