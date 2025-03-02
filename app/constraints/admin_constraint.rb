# frozen_string_literal: true

# Used in routes.rb for admin-only routes
class AdminConstraint
  class << self
    def matches?(request)
      user = Current.user
      return false unless user

      user.admin?
    end
  end
end
