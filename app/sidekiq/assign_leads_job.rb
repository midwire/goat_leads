# frozen_string_literal: true

class AssignLeadsJob
  include Sidekiq::Job
  sidekiq_options queue: :critical

  def perform
    leads = Lead.unassigned.oldest_first

    # For each lead, assign it to an appropriate user with weighted priority
    leads.each do |lead|
      LeadDistributor.assign_lead(lead)
    end
  end
end
