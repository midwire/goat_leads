json.extract! lead_order, :id, :user_id, :expire_on, :lead_class, :active, :max_per_day, :paused_until, :days_per_week, :states, :created_at, :updated_at
json.url lead_order_url(lead_order, format: :json)
