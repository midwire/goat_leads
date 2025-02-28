# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  DATE_FORMAT = :mdy_slash

  # Define methods for all decorated objects.
  # Helpers are accessed through `helpers` (aka `h`). For example:
  #
  #   def percent_amount
  #     h.number_to_percentage object.amount, precision: 2
  #   end

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def mdy_date(date)
    return '' if date.blank?

    date.to_fs(DATE_FORMAT)
  end

  def ymd_date(date)
    return '' if date.blank?

    date.to_fs(:ymd)
  end

  def comma_number(number)
    h.number_with_delimiter(number, delimiter: ',')
  end

  def linked_email
    h.email_link(email1)
  end
end
