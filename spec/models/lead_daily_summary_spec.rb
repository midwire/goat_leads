# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadDailySummary, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: lead_daily_summaries
#
#  id         :bigint           not null, primary key
#  date       :date             not null
#  lead_count :integer          default(0), not null
#  lead_type  :string           not null
#  total_cost :decimal(10, 2)   default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_lead_daily_summaries_on_date_and_lead_type  (date,lead_type) UNIQUE
#
