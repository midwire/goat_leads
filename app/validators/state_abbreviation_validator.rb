# frozen_string_literal: true

class StateAbbreviationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return nil if value.blank? # blank states is acceptable

    if value.is_a?(Array)
      values = value.split(',').flatten
      values.each do |abbr|
        validate_abbr(record, attribute, abbr)
      end
    else
      validate_abbr(record, attribute, value)
    end
  end

  private

  def validate_abbr(record, attribute, abbr)
    return if valid_abbreviations.include?(abbr)

    record.errors.add(attribute, "'#{abbr}' is not a valid state abbreviation")
  end

  def valid_abbreviations
    @valid_abbreviations ||= State.all
  end
end
