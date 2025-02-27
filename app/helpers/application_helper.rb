# frozen_string_literal: true

module ApplicationHelper
  def current_user
    Current.user
  end

  def active_class(path)
    if request.path == path
      'active'
    else
      ''
    end
  end
end
