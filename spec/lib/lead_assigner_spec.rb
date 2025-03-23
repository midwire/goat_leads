# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadAssigner, type: :lib do
  describe '.assign_lead' do
    let(:lead) { create(:veteran_lead_premium) }

    context 'with no eligible lead order' do
      it 'returns nil when no lead orders match criteria' do
        create(:lead_order, states: %w[tx], lead_class: 'VeteranLeadPremium')
      end
    end
  end
end
