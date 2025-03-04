# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Faq, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :string
#  order      :integer
#  question   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_faqs_on_order  (order) UNIQUE
#
