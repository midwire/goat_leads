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

  def user_initial_circle(full_name, size: 40)
    # Extract initials from full name
    parts = full_name.split(/\s+/)
    first_initial = parts.first[0] || ''
    last_initial = parts.last[0] || ''
    initials = "#{first_initial}#{last_initial}"

    # Generate a random background color
    # random_color = '#%06x' % (rand * 0xffffff)
    hue = rand(0..360)
    saturation = rand(20..50)
    lightness = rand(10..40)
    random_color = "hsl(#{hue}, #{saturation}%, #{lightness}%)"

    # Calculate font size and positioning based on circle size
    font_size = size * 0.4 # 40% of the circle size for readability
    text_x = size / 2
    text_y = size / 2 + font_size * 0.20 # Adjust for vertical centering

    # Generate the SVG
    content_tag(:svg, width: size, height: size, class: 'rounded-circle') do
      concat(content_tag(:circle, nil, cx: size / 2, cy: size / 2, r: size / 2, fill: random_color))
      concat(content_tag(:text, initials, x: text_x, y: text_y, fill: '#ffffff', "font-size": font_size,
        "font-family": 'Arial, sans-serif', "text-anchor": 'middle', "dominant-baseline": 'middle'))
    end
  end
end
