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
        agent_visible: false
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
      'needed_coverage' => {
        method: 'needed_coverage',
        display: 'Needed Coverage',
        source: 'Lead.needed_coverage',
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
      'user_id' => {
        method: 'owner',
        display: 'Owner',
        source: 'User.email',
        cond: :like,
        agent_visible: true,
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
        source: 'Lead.campaign',
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
end
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/MethodLength
