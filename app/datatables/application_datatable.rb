# frozen_string_literal: true

# rubocop:disable Rails/OutputSafety
class ApplicationDatatable < AjaxDatatablesRails::ActiveRecord
  include Rails.application.routes.url_helpers

  self.nulls_last = true

  private

  def linked(url, label)
    "<a href='#{url}'>#{label}</a>".html_safe
  end

  def buttoned(url, label)
    html = <<~STRING
      <a href='#{url}' class='button is-link', title='Click for property detail and comparables.'>
        #{label}
      </a>
    STRING
    html.html_safe
  end
end
# rubocop:enable Rails/OutputSafety
