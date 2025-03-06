# frozen_string_literal: true

class LeadDistributor
  class << self
    def assign_lead(lead, max_attempts: 3)
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
      User.agent
          .where.not(email_verified_at: nil)
          .where(lead_status: true)
          .where('licensed_states @> ARRAY[?]::text[]', lead.rr_state)
          .where('lead_types @> ARRAY[?]::text[]', lead.type)
          .where('video_types @> ARRAY[?]::text[]', lead.video_type)
          # Offset by attempt number to try different users if first choice fails
          .order(deliver_priority: :asc, last_lead_delivered_at: :asc)
          .offset(attempt)
          .first
    end

    # rubocop:disable Metrics/AbcSize
    def assign_lead_to_user?(lead, user)
      ActiveRecord::Base.transaction do
        # Lock the user row to prevent race conditions
        user.lock!

        # Double-check availability within transaction
        return false unless user.lead_status &&
            user.licensed_states.include?(lead.rr_state) &&
            user.lead_types.include?(lead.type) &&
            user.video_types.include?(lead.video_type)

        lead.update!(user: user)
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
