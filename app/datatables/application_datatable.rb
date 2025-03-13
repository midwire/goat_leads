# frozen_string_literal: true

# rubocop:disable Rails/OutputSafety
class ApplicationDatatable < AjaxDatatablesRails::ActiveRecord
  include Rails.application.routes.url_helpers

  self.nulls_last = true

  private

  def linked(url, label, alt = nil)
    "<a href='#{url}' alt='#{alt}' title='#{alt}'>#{label}</a>".html_safe
  end

  def buttoned(url, label)
    html = <<~STRING
      <a href='#{url}' class='btn btn-primary', title='Click to Edit.'>
        #{label}
      </a>
    STRING
    html.html_safe
  end
end
# rubocop:enable Rails/OutputSafety
