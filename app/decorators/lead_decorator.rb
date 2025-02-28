# frozen_string_literal: true

class LeadDecorator < ApplicationDecorator
  include ApplicationHelper
  delegate_all

  def owner
    return 'Unassigned' unless object.user

    object.user.display_name
  end
end
