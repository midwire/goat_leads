# frozen_string_literal: true

module ApplicationHelper
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

  def flash_classes(level)
    classes = %w[toast alert d-flex]
    case level.to_sym
    when :notice, :info
      classes << 'alert-info'
    when :success
      classes << 'alert-success'
    when :error
      classes << 'alert-danger'
    when :alert, :warn, :warning
      classes << 'alert-warning'
    end
  end
end
