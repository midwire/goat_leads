# frozen_string_literal: true

module LeadClassMapping
  extend ActiveSupport::Concern

  LEAD_CLASS_MAP = {
    'Aged FEX Leads' => 'FinalExpenseLead',
    'Aged IUL Leads' => 'IndexUniversalLead',
    'Aged MP Leads' => 'MortgageProtectionLead',
    'Aged Vet IUL, FEX' => 'VeteranLead',
    'FEX Leads' => 'FinalExpenseLead',
    'IUL Leads' => 'IndexUniversalLead',
    'Mortgage Protection Leads' => 'MortgageProtectionLead',
    'Real-Time Vet IUL, FEX' => 'VeteranLead'
  }.freeze

  included do
    def lead_class(lead_program, lead_quality)
      base_class = LEAD_CLASS_MAP[lead_program]
      klass = append_lead_quality(base_class, lead_quality)
      return klass unless klass.nil?

      msg = "Lead program: '#{lead_program}' is not mapped to a lead class."
      Rails.logger.error(msg)
      fail msg
    end

    private

    def append_lead_quality(base_class, lead_quality)
      "#{base_class}#{lead_quality}"
    end
  end

  class_methods do
  end
end
