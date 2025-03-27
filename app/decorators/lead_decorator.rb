# frozen_string_literal: true

class LeadDecorator < ApplicationDecorator
  include ApplicationHelper
  delegate_all

  def owner
    return 'Unassigned' unless object.lead_order&.user

    object.lead_order.user.decorate&.display_name
  end

  def display_name
    return object.full_name if object.full_name.present?

    fname = object.first_name
    lname = object.last_name
    return object.email_address.downcase if fname.blank? && lname.blank?

    [fname, lname].join(' ')
  end

  def days_ago
    date = object.created_at
    return 'invalid date' unless date.respond_to?(:to_date)

    days_diff = (Date.current - date.to_date).to_i

    case days_diff
    when 0 then 'today'
    when 1 then 'yesterday'
    when 2..Float::INFINITY then "#{days_diff} days ago"
    else 'in the future'
    end
  end

  def current_age
    return 'N/A' if object.dob.blank?

    calculate_age(object.dob)
  end

  def created_at
    datetime_format(object.created_at)
  end

  def new_lead
    'New Lead'
  end

  private

  def calculate_age(dob)
    current_date = Date.current
    age = current_date.year - dob.year
    age -= 1 if current_date < Date.new(current_date.year, dob.month, dob.day)
    age
  end

end
