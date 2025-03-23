# frozen_string_literal: true

class LeadAssigner
  class << self
    def assign_lead(lead, max_attempts: 3)
      return nil unless lead.valid? # Don't assign invalid leads
      return nil if lead.delivered? # Don't re-assign leads

      attempt = 0

      while attempt < max_attempts
        lead_order = find_next_eligible_lead_order(lead, attempt)
        return nil unless lead_order

      end
    end

    private

    def find_next_eligible_lead_order
      LeadOrder.where(id: 1)
    end
  end
end
