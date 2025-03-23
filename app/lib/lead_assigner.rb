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

        if assign_lead_to_lead_order?(lead, lead_order)
          user = lead_order.user
          Rails.logger.info "Lead #{lead.id} assigned to user #{user.id} (#{user.email_address})"
          return lead_order
        end

        attempt += 1
      end

      Rails.logger.warn "Failed to assign lead #{lead.id} after #{max_attempts} attempts"
      nil
    end

    private

    def find_next_eligible_lead_order(lead, attempt)
      LeadOrder.eligible_for_lead(lead).offset(attempt).first
    end

    def assign_lead_to_lead_order?(lead, lead_order)
      ActiveRecord::Base.transaction do
        # Lock the lead_order row to prevent race conditions
        lead_order.lock!

        # Double-check availability within transaction
        return false unless lead_order.active &&
            lead_order.states.include?(lead.rr_state) &&
            lead_order.lead_class = lead.type

        assign_lead!(lead, lead_order)

        true
      end
    rescue ActiveRecord::LockWaitTimeout => e
      Rails.logger.error "LeadOrder is locked #{lead_order.id}: #{e.message}"
      false
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to assign lead #{lead.id} to lead order #{lead_order.id}: #{e.message}"
      false
    end

    def assign_lead!(lead, lead_order)
      now = Time.current
      user = lead_order.user
      user.update!(last_lead_delivered_at: now)
      lead.update!(delivered_at: now, lead_order: lead_order)
      lead_order.update!(last_lead_delivered_at: now)
    end
  end
end
