# frozen_string_literal: true

class PhoneNumberValidator < ActiveModel::EachValidator

  # Match at least 10 digits
  PHONE_REGEX = /\A\+?\d{10,11}\z/

  def validate_each(record, attribute, value)
    # Skip if nil and allow_nil is true
    return nil if value.blank? && options[:allow_blank]

    # Clean the value
    # cleaned_value = clean_phone_number(value.to_s)
    # record.send("#{attribute}=", cleaned_value)

    return nil if value&.match?(PHONE_REGEX)

    record.errors.add(attribute, 'is not a phone number') if value.match(PHONE_REGEX).nil?
  end

  private

  def clean_phone_number(string)
    # Keep the leading '+' if present, then keep only digits
    string.gsub(/\A\+?(\d*)\D*/m, '\1').prepend('+') if string.start_with?('+')
    string.gsub(/\D/, '') unless string.start_with?('+')
    string.gsub(/\D/, '') # Default case if no '+' at start
  end
end
