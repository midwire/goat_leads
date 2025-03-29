# frozen_string_literal: true

class LeadOrderDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def days_per_week
    object.days_per_week.join(', ')
  end

  def states
    object.states.join(', ')
  end

  def paused_until
    return 'Not Paused' if object.paused_until.blank?

    object.paused_until
  end

  def canceled_at
    return 'Not Canceled' if object.canceled_at.blank?

    object.canceled_at
  end

  def ordered_date
    return mdy_date(object.ordered_at) if object.ordered_at.present?

    mdy_date(object.created_at)
  end

  def active
    return 'paused' unless object.active

    object.active
  end
end
