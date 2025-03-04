# frozen_string_literal: true

class Faq < ApplicationRecord
  default_scope -> { order(order: :asc) }
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
