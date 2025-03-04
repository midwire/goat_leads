# frozen_string_literal: true

FactoryBot.define do
  factory :faq do
    order { 1 }
    question { 'MyString' }
    answer { 'MyString' }
  end
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
