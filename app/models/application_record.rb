# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  private

  def permitted_days_per_week
    %w[mon tue wed thu fri sat sun]
  end
end
