# spec/concerns/fex_lead_common_spec.rb
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FexLeadCommon, type: :concern do
  # Define a test class that includes the concern
  let(:test_class) do
    Class.new do
      include FexLeadCommon

      def decorate
        self
      end
    end
  end

  let(:lead) { test_class.new }
  let(:decorated_lead) { double('DecoratedLead') }

  before do
    # Stub decorate to return the decorated_lead double
    allow(lead).to receive(:decorate).and_return(decorated_lead)
    # Stub Settings.whitelabel.site_title
    allow(Settings).to receive(:whitelabel).and_return(double(site_title: 'FEX Site'))
  end

  describe '#spreadsheet_data' do
    it 'returns a hash with expected column mappings' do
      expected_data = {
        'Date/Time' => :created_at,
        'First Name' => :first_name,
        'Last Name' => :last_name,
        'DOB' => :dob,
        'Phone' => :phone,
        'Email' => :email,
        'Ad' => :ad,
        'Status' => :new_lead,
        'State' => :state,
        'RR State' => :rr_state,
        'Owner' => :owner,
        'Notes' => nil,
        'Date' => :lead_date,
        'Amt Requested' => :amt_requested,
        'Beneficiary' => :beneficiary,
        'Beneficiary Name' => :beneficiary_name,
        'Age' => :current_age,
        'Platform' => :platform,
        'Gender' => :gender,
        'History of Heart Attack Stroke Cancer' => :health_history,
        'Have Life Insurance' => :has_life_insurance,
        'Favorite Hobby' => :favorite_hobby
      }

      expect(lead.spreadsheet_data).to eq(expected_data)
    end
  end

  describe '#to_ringy_format' do
    before do
      allow(decorated_lead).to receive_messages(
        first_name: 'John',
        last_name: 'Doe',
        phone: '+1234567890',
        email: 'john.doe@example.com',
        state: 'CA',
        amt_requested: '5000',
        beneficiary: 'Spouse',
        beneficiary_name: 'Jane Doe',
        platform: 'YouTube',
        dob: Date.new(1980, 1, 1),
        age: 43,
        ad: 'Google Ad',
        type: 'Premium',
        otp_code: 'XYZ123'
      )
    end

    it 'returns a hash formatted for Ringy' do
      expected_format = {
        phone_number: '+1234567890',
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        dob: '1980-01-01',
        ad: 'Google Ad',
        status: 'New Lead',
        state: 'CA',
        notes: '',
        amt_requested: '5000',
        beneficiary: 'Spouse',
        beneficiary_name: 'Jane Doe',
        age: 43,
        platform: 'YouTube',
        lead_source: 'FEX Site'
      }

      expect(lead.to_ringy_format).to eq(expected_format)
    end

    context 'when dob is nil' do
      before { allow(decorated_lead).to receive(:dob).and_return(nil) }

      it 'includes dob as nil in the hash' do
        result = lead.to_ringy_format
        expect(result[:dob]).to be_nil
      end
    end
  end

  describe '#sms_message' do
    before do
      allow(decorated_lead).to receive_messages(
        first_name: 'John',
        last_name: 'Doe',
        phone: '+1234567890',
        email: 'john.doe@example.com',
        state: 'CA',
        dob: Date.new(1980, 1, 1),
        age: 43,
        ad: 'Google Ad',
        type: 'Premium',
        otp_code: 'XYZ123'
      )
    end

    it 'returns an array of SMS message lines' do
      expected_message = [
        'New FEX Lead! Sell It!',
        'Name: John Doe',
        'Phone: +1234567890',
        'Email: john.doe@example.com',
        'State: CA',
        'DOB/Age: 1980-01-01/43',
        'Ad: Google Ad',
        'Lead Type: Premium',
        'OTP Code: XYZ123',
        '',
        'OTP Now ENABLED on all FEX Leads From Google/YouTube!',
        '',
        'Check Your Email For More Details!'
      ].join("\n")

      expect(lead.sms_message(lead)).to eq(expected_message)
    end

    context 'when some fields are nil' do
      before do
        allow(decorated_lead).to receive_messages(
          email: nil,
          otp_code: nil
        )
      end

      it 'includes nil fields as empty or default strings' do
        result = lead.sms_message(lead)
        expect(result).to include('Email: ')
        expect(result).to include('OTP Code: ')
      end
    end
  end
end
