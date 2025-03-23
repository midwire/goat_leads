# frozen_string_literal: true

class AssignLeadsJob
  include Sidekiq::Job
  sidekiq_options queue: :critical,
    lock: :until_executed,
    on_conflict: :reject
  # lock: :while_executing,
  # lock_timeout: nil,
  # on_conflict: {
  #   client: :log,
  #   server: :reschedule
  # }

  def perform
    leads = Lead.unassigned.oldest_first

    # For each lead, assign it to an appropriate user with weighted priority
    leads.each do |lead|
      LeadAssigner.assign_lead(lead)
    end
  end
end
