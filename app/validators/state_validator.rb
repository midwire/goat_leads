# frozen_string_literal: true

class StateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # Allow state name or abbreviation
    # state_hash = State::LOOKUP_TABLE.map { |k, v| [k.downcase, v.downcase] }
    # return nil if state_hash.to_a.flatten.include?(value&.downcase)

    # Allow state abbreviation only
    # return nil if State::LOOKUP_TABLE.keys.map(&:downcase).include?(value.downcase)

    # Allow state name only
    return nil if State::LOOKUP_TABLE.values.map(&:downcase).include?(value.downcase)

    record.errors.add(attribute, (options[:message] || 'is not a valid state'))
  end
end
