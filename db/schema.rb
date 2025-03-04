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

ActiveRecord::Schema[8.0].define(version: 2025_03_04_193439) do
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
    t.string "lead_type"
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
    t.index ["dob"], name: "index_leads_on_dob"
    t.index ["email"], name: "index_leads_on_email"
    t.index ["first_name"], name: "index_leads_on_first_name"
    t.index ["last_name"], name: "index_leads_on_last_name"
    t.index ["phone"], name: "index_leads_on_phone"
    t.index ["state"], name: "index_leads_on_state"
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
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["email_verified_at"], name: "index_users_on_email_verified_at"
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "sessions", "users"
end
