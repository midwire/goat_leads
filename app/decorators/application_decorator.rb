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

  def datetime_format(time)
    return '' if time.blank?

    time.strftime('%-m/%-d/%Y %H:%M:%S')
  end

  def comma_number(number)
    h.number_with_delimiter(number, delimiter: ',')
  end

  def linked_email(email)
    h.email_link(email)
  end

  def time_ago_in_words(past_time)
    time_diff = Time.current - past_time
    case time_diff
    when 0...60
      "#{time_diff.round} seconds ago"
    when 60...3600
      "#{(time_diff / 60).round} minutes ago"
    when 3600...86400
      "#{(time_diff / 3600).round} hours ago"
    when 86400...2592000
      "#{(time_diff / 86400).round} days ago"
    when 2592000...31104000
      "#{(time_diff / 2592000).round} months ago"
    else
      "#{(time_diff / 31104000).round} years ago"
    end
  end
end
