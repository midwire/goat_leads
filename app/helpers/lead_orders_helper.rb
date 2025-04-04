# frozen_string_literal: true

module LeadOrdersHelper
  # Define table display columns
  # rubocop:disable Metrics/MethodLength
  def display_table_cols(current_user)
    if current_user.admin?
      {
        id: 'ID',
        lead_class: 'Lead Type',
        user: 'Owner',
        fulfilled: 'Fulfilled',
        active: 'Paused',
        canceled_at: 'Canceled',
        expire_on: 'Expire On',
        total_lead_order: 'Total Leads'
      }
    else
      {
        lead_class: 'Lead Type',
        total_lead_order: 'Total Lead Cap',
        max_per_day: 'Max per Day',
        states: 'States',
        days_per_week: 'Days per Week',
        agent_email: 'Email To',
        agent_phone: 'Phone',
        active: 'Active',
        expire_on: 'Expire On',
        paused_until: 'Paused Until'
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  def cancel_order_confirmation_text
    'Leads flows for this order will cease. Are you sure you want to cancel?'
  end

  def lead_class_options
    Rails.application.eager_load!
    ObjectSpace.each_object(Class).select { |klass| klass < Lead }.map(&:to_s).sort
  end
end
