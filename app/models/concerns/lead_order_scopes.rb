# frozen_string_literal: true

module LeadOrderScopes
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    scope :active, -> { where(active: true) }
    scope :fulfilled, -> { where.not(fulfilled_at: nil) }
    scope :not_fulfilled, -> { where(fulfilled_at: nil) }
    scope :for_user, ->(user) { where(user_id: user.respond_to?(:id) ? user.id : user) }
    scope :not_canceled, -> { where(canceled_at: nil) }
    scope :not_expired, lambda {
      where(
        arel_table[:expire_on].eq(nil).or(
          arel_table[:expire_on].gt(Time.current)
        )
      )
    }
    scope :for_lead_type, ->(lead_type) { where(lead_class: lead_type) }
    scope :for_day_of_week, lambda { |dow = Date.current.strftime('%a').downcase|
      where('days_per_week @> ARRAY[?]::text[]', dow)
    }
    scope :for_state, lambda { |state_abbr|
      where('states @> ARRAY[?]::text[]', state_abbr)
    }
    scope :with_unreached_daily_cap_of, lambda { |cap|
      where(
        arel_table[:max_per_day].eq(nil).or(
          arel_table[:max_per_day].eq(0).or(
            arel_table[:max_per_day].gt(cap)
          )
        )
      )
    }
    scope :with_unreached_total_cap, lambda {
      sql = <<-SQL.squish
        LEFT JOIN (
          SELECT lead_order_id, COUNT(*) AS leads_delivered_total
          FROM leads
          GROUP BY lead_order_id
        ) ld_total ON ld_total.lead_order_id = lead_orders.id
      SQL
      joins(sql).where(
        <<-SQL.squish
          (
            COALESCE(ld_total.leads_delivered_total, 0) < lead_orders.total_lead_order
          )
        SQL
      )
    }
    scope :with_unreached_daily_cap, lambda { |date = Time.current.strftime('%Y-%m-%d')|
      raw_sql = <<-SQL.squish
        LEFT JOIN (
          SELECT lead_order_id, COUNT(*) AS leads_delivered_today
          FROM leads
          WHERE DATE(delivered_at) = ?
          GROUP BY lead_order_id
        ) ld_daily ON ld_daily.lead_order_id = lead_orders.id
      SQL
      sql = sanitize_sql_array([raw_sql, date])
      joins(sql).where(
        <<-SQL.squish
          (
            lead_orders.max_per_day IS NULL
            OR COALESCE(ld_daily.leads_delivered_today, 0) < lead_orders.max_per_day
          )
        SQL
      )
    }

    # SORTING
    scope :by_last_delivered, lambda {
      order(arel_table[:last_lead_delivered_at].asc.nulls_first)
    }
    scope :by_delivery_priority, lambda {
      # TODO: Calculate the delivery priority and use it here
    }

    # LEAD ELIGIBILITY
    # This scope uses most of the others for lead eligibility
    scope :eligible_for_lead, lambda { |lead|
      joins(:user)
          .merge(User.agent)
          # .merge(User.verified)  # TODO: Enable this after we get users verified
          .merge(User.available)
          .not_canceled
          .not_expired
          .not_fulfilled
          .for_state(lead.rr_state)
          .for_day_of_week
          .for_lead_type(lead.type)
          .with_unreached_daily_cap
          .with_unreached_total_cap
          .by_last_delivered
      # .by_delivery_priority # TODO: Enable this when ready
    }
  end
  # rubocop:enable Metrics/BlockLength
end
