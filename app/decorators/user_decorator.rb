# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  include ApplicationHelper
  delegate_all

  def owner
    return 'Unassigned' unless object.user

    object.user.display_name
  end

  def display_name
    fname = object.first_name
    lname = object.last_name
    return object.email_address if fname.blank? && lname.blank?

    [fname, lname].join(' ')
  end

  def last_lead_delivered_at
    if object.last_lead_delivered_at
      ymd_date(object.last_lead_delivered_at)
    else
      'N/A'
    end
  end
end
