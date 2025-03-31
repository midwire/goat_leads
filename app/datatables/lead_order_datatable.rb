# frozen_string_literal: true

class LeadOrderDatatable < ApplicationDatatable

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      id: { source: 'LeadOrder.id', cond: :eq },
      user: { source: 'User.email_address', cond: :like },
      canceled_at: { source: 'LeadOrder.canceled_at', cond: :eq },
      expire_on: { source: 'LeadOrder.expire_on', cond: :eq },
      days_per_week: { source: 'LeadOrder.days_per_week', cond: :like },
      max_per_day: { source: 'LeadOrder.max_per_day', cond: :like },
      total_lead_order: { source: 'LeadOrder.total_lead_order', cond: :like },
      lead_class: { source: 'LeadOrder.lead_class', cond: :like },
      paused_until: { source: 'LeadOrder.paused_until', cond: :like },
      states: { source: 'LeadOrder.states', cond: :like },
      agent_email: { source: 'LeadOrder.agent_email', cond: :like },
      agent_phone: { source: 'LeadOrder.agent_phone', cond: :like },
      active: { source: 'LeadOrder.active', cond: :eq }
    }
  end

  # rubocop:disable Metrics/AbcSize
  def data
    records.map do |record|
      lead_order = record.decorate
      {
        id: lead_order.id,
        user: lead_order.user.decorate.email_address,
        canceled_at: lead_order.canceled_at,
        expire_on: lead_order.expire_on,
        days_per_week: lead_order.days_per_week,
        max_per_day: lead_order.max_per_day,
        total_lead_order: lead_order.total_lead_order,
        lead_class: linked(edit_lead_order_url(lead_order), lead_order.lead_class, 'Edit Lead Order'),
        # lead_class: buttoned(edit_lead_order_url(lead_order), lead_order.lead_class),
        # lead_class: lead_order.lead_class,
        paused_until: lead_order.paused_until,
        states: lead_order.states,
        agent_email: lead_order.agent_email,
        agent_phone: lead_order.agent_phone,
        active: lead_order.active,
        DT_RowId: record.id
      }
    end
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Naming/AccessorMethodName
  def get_raw_records
    if user.admin?
      LeadOrder.order(lead_class: :asc).joins(:user).includes(:user)
    else
      user.lead_orders.order(lead_class: :asc).not_canceled.joins(:user).includes(:user)
    end
  end
  # rubocop:enable Naming/AccessorMethodName

  private

  def user
    @user ||= options[:user]
  end
end
