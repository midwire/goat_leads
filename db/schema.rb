# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_21_184901) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "faqs", force: :cascade do |t|
    t.integer "order"
    t.string "question"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order"], name: "index_faqs_on_order", unique: true
  end

  create_table "lead_orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "expire_on"
    t.datetime "canceled_at"
    t.string "lead_class"
    t.boolean "active"
    t.integer "max_per_day"
    t.date "paused_until"
    t.text "days_per_week", default: ["mon", "tue", "wed", "thu", "fri", "sat", "sun"], array: true
    t.text "states", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "google_sheet_url"
    t.string "ghl_api_key"
    t.string "ringy_sid"
    t.string "ringy_auth_token"
    t.boolean "send_text"
    t.boolean "send_email"
    t.datetime "fulfilled_at"
    t.string "detail"
    t.string "agent_name"
    t.integer "amount_cents"
    t.integer "discount_cents"
    t.integer "paid_cents"
    t.integer "frequency"
    t.integer "count"
    t.string "lead_program"
    t.string "lead_type"
    t.string "agent_email"
    t.string "agent_phone"
    t.string "agent_sheet"
    t.string "url_source"
    t.integer "quantity"
    t.integer "total_leads"
    t.integer "bump_order"
    t.integer "total_lead_order"
    t.string "order_id"
    t.string "name_on_sheet"
    t.string "imo"
    t.string "notes"
    t.datetime "ordered_at"
    t.index ["active"], name: "index_lead_orders_on_active"
    t.index ["agent_email"], name: "index_lead_orders_on_agent_email"
    t.index ["agent_phone"], name: "index_lead_orders_on_agent_phone"
    t.index ["expire_on"], name: "index_lead_orders_on_expire_on"
    t.index ["fulfilled_at"], name: "index_lead_orders_on_fulfilled_at"
    t.index ["lead_class"], name: "index_lead_orders_on_lead_class"
    t.index ["order_id"], name: "index_lead_orders_on_order_id", unique: true
    t.index ["user_id"], name: "index_lead_orders_on_user_id"
  end

  create_table "leads", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.string "state"
    t.date "dob"
    t.string "marital_status"
    t.string "military_status"
    t.string "needed_coverage"
    t.string "contact_time_of_day"
    t.string "rr_state"
    t.string "ad"
    t.string "adset_id"
    t.bigint "user_id"
    t.string "platform"
    t.string "campaign_id"
    t.string "ringy_code"
    t.string "lead_program"
    t.string "ip_address"
    t.string "location"
    t.string "trusted_form_url"
    t.boolean "verified_lead"
    t.boolean "unique"
    t.boolean "policy_sold"
    t.date "sold_on"
    t.string "agent_sold"
    t.string "carrier_sold"
    t.string "premium_sold"
    t.integer "lead_age"
    t.date "resold_on"
    t.string "resold_owner"
    t.string "external_lead_id"
    t.string "video_type"
    t.string "the_row"
    t.date "lead_date"
    t.string "real_owner_name"
    t.integer "age"
    t.boolean "veteran"
    t.string "branch_of_service"
    t.string "lead_quality"
    t.string "outside_company"
    t.string "google_click_id"
    t.datetime "lead_form_at"
    t.string "iul_goal"
    t.string "employment_status"
    t.string "monthly_contribution"
    t.string "current_retirement_plan"
    t.integer "retirement_age"
    t.string "lead_form_name"
    t.string "page_url"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_campaign"
    t.string "utm_content"
    t.string "utm_adset"
    t.string "utm_site_source"
    t.string "otp_code"
    t.string "crm"
    t.string "crm_user"
    t.string "crm_date"
    t.string "crm_status"
    t.string "ringy_status"
    t.integer "client_age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "user_agent"
    t.string "utm_owner"
    t.string "utm_id"
    t.string "utm_term"
    t.string "fbclid"
    t.string "full_name"
    t.boolean "is_dropoff"
    t.datetime "delivered_at"
    t.boolean "health_history"
    t.string "beneficiary"
    t.string "beneficiary_name"
    t.string "mortgage_balance"
    t.string "mortgage_payment"
    t.string "desired_monthly_contrib"
    t.string "desired_retirement_age"
    t.string "amt_requested"
    t.string "gender"
    t.string "has_life_insurance"
    t.string "favorite_hobby"
    t.string "address"
    t.string "city"
    t.string "zip"
    t.bigint "lead_order_id"
    t.index ["delivered_at"], name: "index_leads_on_delivered_at"
    t.index ["dob"], name: "index_leads_on_dob"
    t.index ["email"], name: "index_leads_on_email"
    t.index ["first_name"], name: "index_leads_on_first_name"
    t.index ["last_name"], name: "index_leads_on_last_name"
    t.index ["lead_order_id"], name: "index_leads_on_lead_order_id"
    t.index ["phone"], name: "index_leads_on_phone"
    t.index ["state"], name: "index_leads_on_state"
    t.index ["type"], name: "index_leads_on_type"
    t.index ["user_id"], name: "index_leads_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "email_verified_at"
    t.integer "role", default: 0
    t.text "licensed_states", default: [], array: true
    t.integer "deliver_priority", default: 0
    t.text "video_types", default: [], array: true
    t.text "lead_types", default: [], array: true
    t.datetime "last_lead_delivered_at"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.text "notes"
    t.integer "status", default: 0
    t.string "google_sheet_url"
    t.string "ghl_api_key"
    t.string "ringy_sid"
    t.string "ringy_auth_token"
    t.string "external_id"
    t.boolean "send_text", default: false
    t.boolean "send_email", default: true
    t.integer "daily_lead_cap"
    t.integer "total_lead_cap"
    t.index ["deliver_priority"], name: "index_users_on_deliver_priority"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["email_verified_at"], name: "index_users_on_email_verified_at"
    t.index ["external_id"], name: "index_users_on_external_id"
    t.index ["last_lead_delivered_at"], name: "index_users_on_last_lead_delivered_at"
    t.index ["lead_types"], name: "index_users_on_lead_types", using: :gin
    t.index ["licensed_states"], name: "index_users_on_licensed_states", using: :gin
    t.index ["role"], name: "index_users_on_role"
    t.index ["status"], name: "index_users_on_status"
    t.index ["video_types"], name: "index_users_on_video_types", using: :gin
  end

  add_foreign_key "lead_orders", "users"
  add_foreign_key "sessions", "users"
end
