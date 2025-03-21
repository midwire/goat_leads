# frozen_string_literal: true

module ApplicationHelper
  # Whitelabel delegation
  delegate :site_title, to: :Whitelabel
  delegate :site_description, to: :Whitelabel
  delegate :social_media_description, to: :Whitelabel
  delegate :social_media_title, to: :Whitelabel
  delegate :site_domain, to: :Whitelabel

  def app_version
    if File.exist?(Rails.root.join('REVISION'))
      File.read(Rails.root.join('REVISION')).strip
    else
      'unknown'
    end
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

  def tel_to(phone)
    link_to(phone, "tel:#{phone}")
  end

  def nav_link(text, url)
    content_tag(:a, href: url, class: "nav-link #{active_class(url)}") do
      text
    end
  end
end
