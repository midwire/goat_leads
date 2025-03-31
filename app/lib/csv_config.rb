# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/MethodLength
module CsvConfig
  # NOTE: property needs to be decorated for these methods to work
  # The key is the column name, method is the decorator method to call
  def csv_columns_hash
    {
      'id' => {
        method: 'id',
        display: 'ID',
        source: 'Lead.id',
        cond: :eq,
        searchable: true,
        sortable: true,
        agent_visible: true
      },
      'type' => {
        method: 'type',
        display: 'Lead Type',
        source: 'Lead.type',
        cond: :like,
        searchable: true,
        sortable: true,
        agent_visible: true
      },
      'first_name' => {
        method: 'first_name',
        display: 'First Name',
        source: 'Lead.first_name',
        cond: :like,
        searchable: true,
        sortable: true,
        agent_visible: true
      },
      'last_name' => {
        method: 'last_name',
        display: 'Last Name',
        source: 'Lead.last_name',
        cond: :like,
        searchable: true,
        sortable: true,
        agent_visible: true
      },
      'full_name' => {
        method: 'full_name',
        display: 'Name',
        source: 'Lead.full_name',
        cond: :like,
        searchable: true,
        sortable: true,
        agent_visible: true
      },
      'created_at' => {
        method: 'created_at',
        display: 'Created',
        source: 'Lead.created_at',
        cond: :like,
        searchable: true,
        sortable: true,
        agent_visible: true
      },
      'phone' => {
        method: 'phone',
        display: 'Phone',
        source: 'Lead.phone',
        cond: :like,
        searchable: true,
        sortable: true,
        agent_visible: true
      },
      'email' => {
        method: 'email',
        display: 'Email',
        source: 'Lead.email',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'state' => {
        method: 'state',
        display: 'State',
        source: 'Lead.state',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'dob' => {
        method: 'dob',
        display: 'DOB',
        source: 'Lead.dob',
        cond: :date_range,
        agent_visible: true,
        searchable: false,
        sortable: true
      },
      'gender' => {
        method: 'gender',
        display: 'Gender',
        source: 'Lead.gender',
        cond: :like,
        agent_visible: true,
        searchable: false,
        sortable: true
      },
      'location' => {
        method: 'location',
        display: 'Location',
        source: 'Lead.location',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'marital_status' => {
        method: 'marital_status',
        display: 'Marital Status',
        source: 'Lead.marital_status',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'military_status' => {
        method: 'military_status',
        display: 'Military Status',
        source: 'Lead.military_status',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'health_history' => {
        method: 'health_history',
        display: 'History of cancer, heart attack, diabetes or stroke',
        source: 'Lead.health_history',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'favorite_hobby' => {
        method: 'favorite_hobby',
        display: 'Favorite Hobby',
        source: 'Lead.favorite_hobby',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'has_life_insurance' => {
        method: 'has_life_insurance',
        display: 'Has Life Insurance',
        source: 'Lead.has_life_insurance',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'needed_coverage' => {
        method: 'needed_coverage',
        display: 'Needed Coverage',
        source: 'Lead.needed_coverage',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'beneficiary' => {
        method: 'beneficiary',
        display: 'Beneficiary',
        source: 'Lead.beneficiary',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'beneficiary_name' => {
        method: 'beneficiary_name',
        display: 'Beneficiary Name',
        source: 'Lead.beneficiary_name',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'contact_time_of_day' => {
        method: 'contact_time_of_day',
        display: 'Best Time Of Day To Contact You',
        source: 'Lead.contact_time_of_day',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'current_retirement_plan' => {
        method: 'current_retirement_plan',
        display: 'Current Retirement Plan',
        source: 'Lead.current_retirement_plan',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'desired_monthly_contrib' => {
        method: 'desired_monthly_contrib',
        display: 'Desired Montly Contribution',
        source: 'Lead.desired_monthly_contrib',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'desired_retirement_age' => {
        method: 'desired_retirement_age',
        display: 'Desired Retirement Age',
        source: 'Lead.desired_retirement_age',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'retirement_age' => {
        method: 'retirement_age',
        display: 'Retirement Age',
        source: 'Lead.retirement_age',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'employment_status' => {
        method: 'employment_status',
        display: 'Employment Status',
        source: 'Lead.employment_status',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'mortgage_balance' => {
        method: 'mortgage_balance',
        display: 'Mortgage Balance',
        source: 'Lead.mortgage_balance',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'mortgage_payment' => {
        method: 'mortgage_payment',
        display: 'Mortgage Payment',
        source: 'Lead.mortgage_payment',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'rr_state' => {
        method: 'rr_state',
        display: 'RR State',
        source: 'Lead.rr_state',
        cond: :eq,
        agent_visible: false,
        searchable: true,
        sortable: true
      },
      'ad' => {
        method: 'ad',
        display: 'Ad',
        source: 'Lead.ad',
        cond: :like,
        agent_visible: false,
        searchable: true,
        sortable: true
      },
      'adset_id' => {
        method: 'adset_id',
        display: 'Adset ID',
        source: 'Lead.adset_id',
        cond: :like,
        agent_visible: false,
        searchable: true,
        sortable: true
      },
      'owner' => {
        method: 'owner',
        display: 'Owner',
        source: 'LeadOrder.user_id',
        cond: :like,
        agent_visible: false,
        searchable: true,
        sortable: true
      },
      'platform' => {
        method: 'platform',
        display: 'Platform',
        source: 'Lead.platform',
        cond: :like,
        agent_visible: false,
        searchable: true,
        sortable: true
      },
      'campaign_id' => {
        method: 'campaign_id',
        display: 'Campaign',
        source: 'Lead.campaign_id',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      },
      'ip_address' => {
        method: 'ip_address',
        display: 'IP Address',
        source: 'Lead.ip_address',
        cond: :like,
        agent_visible: true,
        searchable: true,
        sortable: true
      }
    }
  end

  def agent_visible_columns_hash
    csv_columns_hash.select { |_col, data| data[:agent_visible] }
  end

  def admin_visible_columns_hash
    csv_columns_hash
  end
end
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/MethodLength
