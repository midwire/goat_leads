# frozen_string_literal: true

class PhoneNumberValidator < ActiveModel::EachValidator
  # Match at least 10 digits
  PHONE_REGEX = /\A\d{10,}\z/

  def validate_each(record, attribute, value)
    # return nil if value.blank? # blank phone is acceptable
    return nil if value.match?(PHONE_REGEX)

    record.errors.add(attribute, 'is not a phone number') if value.match(PHONE_REGEX).nil?
  end
end
