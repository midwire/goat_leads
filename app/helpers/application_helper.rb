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

  def active_sidebar_class(path)
    if request.path == path
      'list-group-item-primary'
    else
      ''
    end
  end
end
