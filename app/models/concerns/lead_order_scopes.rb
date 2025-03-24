# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
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

    scope :by_delivery_priority, lambda {
      # Constants
      three_days_in_seconds = 3 * 24 * 60 * 60 # 3 days
      recency_threshold_in_seconds = 1 * 24 * 60 * 60 # 1 day
      current_time = Time.current

      # Subquery to count delivered leads per lead order (same as with_unreached_total_cap)
      delivered_leads_subquery = <<-SQL.squish
        LEFT JOIN (
          SELECT lead_order_id, COUNT(*) AS leads_delivered_count
          FROM leads
          GROUP BY lead_order_id
        ) delivered_leads ON delivered_leads.lead_order_id = lead_orders.id
      SQL

      # Calculate components of the score
      # W: Order size weight (total_lead_order)
      w = 'lead_orders.total_lead_order'

      # B: Backlog factor
      # time_since_order = current_time - ordered_at (in seconds)
      time_since_order = <<-SQL.squish
        EXTRACT(EPOCH FROM (TIMESTAMP '#{current_time.to_formatted_s(:db)}' - lead_orders.ordered_at))
      SQL
      # time_ratio = time_since_order / 3 days
      time_ratio = "(#{time_since_order}::float / #{three_days_in_seconds})"
      # fulfillment_ratio = delivered_leads / total_lead_order
      fulfillment_ratio = <<-SQL.squish
        (COALESCE(delivered_leads.leads_delivered_count, 0)::float / NULLIF(lead_orders.total_lead_order, 0))
      SQL
      # backlog_factor = CASE WHEN fulfillment_ratio < time_ratio THEN 1 + (time_ratio - fulfillment_ratio) ELSE 1 END
      backlog_factor = <<-SQL.squish
        CASE
          WHEN #{fulfillment_ratio} < #{time_ratio}
          THEN 1 + (#{time_ratio} - #{fulfillment_ratio})
          ELSE 1
        END
      SQL

      # R: Recency factor
      # time_since_last = current_time - last_lead_delivered_at (in seconds)
      time_since_last = <<-SQL.squish
        EXTRACT(EPOCH FROM (TIMESTAMP '#{current_time.to_formatted_s(:db)}' - lead_orders.last_lead_delivered_at))
      SQL
      # R = CASE WHEN time_since_last > threshold THEN 1 + (time_since_last / 1_day) ELSE 1 END
      recency_factor = <<-SQL.squish
        CASE
          WHEN #{time_since_last} > #{recency_threshold_in_seconds}
          THEN 1 + (#{time_since_last}::float / #{recency_threshold_in_seconds})
          ELSE 1
        END
      SQL

      # Final score: W * B * R
      score = "(#{w}::float * (#{backlog_factor}) * (#{recency_factor}))"

      # Join the subquery and order by score (descending) with tiebreaker
      joins(delivered_leads_subquery)
          .order(Arel.sql("#{score} DESC"))
          .order(arel_table[:last_lead_delivered_at].asc.nulls_first)
    }

    # SORTING
    scope :by_last_delivered, lambda {
      order(arel_table[:last_lead_delivered_at].asc.nulls_first)
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
          .by_delivery_priority
    }
  end
  # rubocop:enable Metrics/BlockLength
end
# rubocop:enable Metrics/ModuleLength
