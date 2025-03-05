# frozen_string_literal: true

class AssignLeadsJob
  include Sidekiq::Job
  sidekiq_options queue: :critical

  def perform(*args)
    # Assignment Logic
    #
    # User Lead Status = on/active
    # User licensed_states contains lead_state
    # User lead-type subscriptions match lead type
    # User video-type matches lead video type (dom, other)
    # User order-type matches lead order_type (Standard, Premium)
    # Order by priority (weight) :ascending - then
    #   Order by lead timestamp :ascending
  end
end
