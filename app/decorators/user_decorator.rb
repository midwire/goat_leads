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
    return object.email if fname.blank? && lname.blank?

    [fname, lname].join(' ')
  end
end
