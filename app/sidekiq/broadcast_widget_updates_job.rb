# frozen_string_literal: true

require 'sidekiq-scheduler'

class BroadcastWidgetUpdatesJob
  include Sidekiq::Job
  sidekiq_options queue: :default,
    lock: :until_executed,
    on_conflict: :reject

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def perform
    # Collect all widget stats
    updates = []

    Sidekiq.logger.info('>>> Sidekiq: BroadcastWidgetUpdatesJob')
    lc = Rails.cache.read('lead_count_changed')
    Sidekiq.logger.info(">>> Sidekiq: lead_count_changed: #{lc}")

    # Lead Count
    if Rails.cache.read('lead_count_changed')
      updates << broadcast(
        widget_id: 'lead_count_widget',
        title: 'Total Leads',
        stat: Lead.count,
        color: :yellow
      )
      Rails.cache.delete('lead_count_changed') # Clear flag
    end

    # Assigned Leads
    if Rails.cache.read('unassigned_lead_count_changed')
      updates << broadcast(
        widget_id: 'unassigned_lead_count_widget',
        title: 'Unassigned Leads',
        stat: Lead.unassigned.count,
        color: :red
      )
      Rails.cache.delete('unassigned_lead_count_changed') # Clear flag
    end

    # LeadOrder Count
    if Rails.cache.read('lead_order_count_changed')
      updates << broadcast(
        widget_id: 'lead_order_count_widget',
        title: 'Lead Orders',
        stat: LeadOrder.count,
        color: :blue
      )
      Rails.cache.delete('lead_order_count_changed') # Clear flag
    end

    # Fulfilled Orders
    if Rails.cache.read('fulfilled_order_count_changed')
      updates << broadcast(
        widget_id: 'fulfilled_order_count_widget',
        title: 'Fulfilled Orders',
        stat: LeadOrder.fulfilled.count,
        color: :green
      )
      Rails.cache.delete('fulfilled_order_count_changed')
    end

    # Broadcast all updates in one message
    return unless updates.any?

    payload = updates.join
    Sidekiq.logger.debug "Broadcasting #{updates.size} updates to dashboard_updates: #{payload}"
    ActionCable.server.broadcast('dashboard_updates', payload)
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  private

  def broadcast(widget_id:, title:, stat:, color:)
    Sidekiq.logger.debug(">>> #{title} changed")
    # Use a controller instance to provide view context
    controller = ApplicationController.new

    Turbo::Streams::TagBuilder.new(controller.view_context).replace(
      widget_id,
      partial: 'dashboards/stat_widget',
      locals: {
        title: title,
        stat: stat,
        color: color,
        id: widget_id,
        turbo_stream: 'dashboard_updates',
        changed: true
      }
    )
  end
end
