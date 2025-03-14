# frozen_string_literal: true

class LeadDistributor
  class << self
    def assign_lead(lead, max_attempts: 6)
      return nil unless lead&.valid?
      return nil if lead&.delivered?

      attempt = 0

      while attempt < max_attempts
        user = find_next_eligible_user(lead, attempt)
        return nil unless user

        if assign_lead_to_user?(lead, user)
          Rails.logger.info "Lead #{lead.id} assigned to user #{user.id} (#{user.email_address})"
          return user
        end

        attempt += 1
      end

      Rails.logger.warn "Failed to assign lead #{lead.id} after #{max_attempts} attempts"
      nil
    end

    private

    def find_next_eligible_user(lead, attempt)
      User.eligible_for_lead(lead).offset(attempt).first
    end

    # rubocop:disable Metrics/AbcSize
    def assign_lead_to_user?(lead, user)
      ActiveRecord::Base.transaction do
        # Lock the user row to prevent race conditions
        user.lock!

        # Double-check availability within transaction
        return false unless user.available? &&
            user.licensed_states.include?(lead.rr_state) &&
            user.lead_types.include?(lead.type) &&
            !user.fulfilled_leads_for_lead_type?(lead.type)

        # user.video_types.include?(lead.video_type)

        lead.update!(user: user, delivered_at: Time.current)

        user.update!(last_lead_delivered_at: Time.current)

        true
      end
    rescue ActiveRecord::LockWaitTimeout => e
      Rails.logger.error "User is locked #{user.id}: #{e.message}"
      false
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to assign lead #{lead.id} to user #{user.id}: #{e.message}"
      false
    end
    # rubocop:enable Metrics/AbcSize
  end
end
