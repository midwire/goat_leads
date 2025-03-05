# frozen_string_literal: true

class CaseInsensitiveHash < Hash
  def [](key)
    super(_insensitive(key))
  end

  def []=(key, value)
    super(_insensitive(key), value)
  end

  protected

  def _insensitive(key)
    key.respond_to?(:downcase) ? key.downcase : key
  end
end
