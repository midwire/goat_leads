class CreateLeads < ActiveRecord::Migration[8.0]
  def change
    create_table :leads do |t|
      t.string :first_name, index: true
      t.string :last_name, index: true
      t.string :phone, index: true
      t.string :email, index: true
      t.string :state, index: true
      t.date :dob, index: true
      t.string :marital_status
      t.string :military_status
      t.string :needed_coverage
      t.string :contact_time_of_day
      t.string :rr_state
      t.string :ad
      t.string :adset_id
      t.bigint :user_id, index: true # Lead Owner
      t.string :platform
      t.string :campaign_id
      t.string :ringy_code
      t.string :lead_program
      t.string :ip_address
      t.string :location
      t.string :trusted_form_url
      t.boolean :verified_lead
      t.boolean :unique
      t.boolean :policy_sold
      t.date :sold_on
      t.string :agent_sold
      t.string :carrier_sold
      t.string :premium_sold
      t.integer :lead_age
      t.date :resold_on
      t.string :resold_owner
      t.string :external_lead_id
      t.string :video_type
      t.string :the_row
      t.date :lead_date
      t.string :real_owner_name
      t.integer :age
      t.boolean :veteran
      t.string :branch_of_service
      t.string :lead_type
      t.string :outside_company
      t.string :google_click_id
      t.datetime :lead_form_at
      t.string :iul_goal
      t.string :employment_status
      t.string :monthly_contribution
      t.string :current_retirement_plan
      t.integer :retirement_age
      t.string :lead_form_name
      t.string :page_url
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_campaign
      t.string :utm_content
      t.string :utm_adset
      t.string :utm_site_source
      t.string :otp_code
      t.string :crm
      t.string :crm_user
      t.string :crm_date
      t.string :crm_status
      t.string :ringy_status
      t.integer :client_age

      t.timestamps
    end
  end
end
