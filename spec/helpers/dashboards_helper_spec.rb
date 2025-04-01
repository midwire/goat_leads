# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DashboardsHelper, type: :helper do
  let(:lead_types) do
    {
      'FinalExpenseLeadPremium' => 2344,
      'FinalExpenseLeadSpanish' => 536,
      'IndexUniversalLifeLeadPremium' => 674,
      'VeteranLeadPremium' => 10430
    }
  end
  let(:lead_order_types) do
    {
      'FinalExpenseLeadAged' => 5,
      'IndexUniversalLeadAged' => 2,
      'FinalExpenseLeadPremium' => 126,
      'IndexUniversalLeadOTP' => 558,
      'IndexUniversalLeadPremium' => 41,
      'VeteranLeadPremium' => 9,
      'Premium' => 23
    }
  end

  describe '#lead_types_without_orders' do
    context 'with lead types and lead order types' do
      it 'returns lead types that have no matching lead orders with their counts' do
        result = helper.lead_types_without_orders(lead_types: lead_types, lead_order_types: lead_order_types)
        expected = { 'FinalExpenseLeadSpanish' => 536, 'IndexUniversalLifeLeadPremium' => 674 }
        expect(result).to eq(expected)
      end
    end

    context 'when all lead types have matching orders' do
      let(:lead_types) do
        {
          'FinalExpenseLeadPremium' => 2344,
          'VeteranLeadPremium' => 10430
        }
      end
      let(:lead_order_types) do
        {
          'FinalExpenseLeadPremium' => 126,
          'VeteranLeadPremium' => 9
        }
      end

      it 'returns an empty array' do
        result = helper.lead_types_without_orders(lead_types: lead_types, lead_order_types: lead_order_types)
        expect(result).to be_empty
      end
    end

    context 'when there are no lead types' do
      let(:lead_types) { {} }
      let(:lead_order_types) do
        {
          'FinalExpenseLeadPremium' => 126,
          'VeteranLeadPremium' => 9
        }
      end

      it 'returns an empty array' do
        result = helper.lead_types_without_orders(lead_types: lead_types, lead_order_types: lead_order_types)
        expect(result).to be_empty
      end
    end

    context 'when there are no lead order types' do
      let(:lead_types) do
        {
          'FinalExpenseLeadPremium' => 2344,
          'VeteranLeadPremium' => 10430
        }
      end
      let(:lead_order_types) { {} }

      it 'returns all lead types' do
        result = helper.lead_types_without_orders(lead_types: lead_types, lead_order_types: lead_order_types)
        expected = { 'FinalExpenseLeadPremium' => 2344, 'VeteranLeadPremium' => 10430 }
        expect(result).to eq(expected)
      end
    end
  end
end
