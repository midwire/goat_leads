# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeadParamNormalizer, type: :lib do
  subject(:norm_params) { described_class.new(raw_params).normalize }

  let(:raw_params) do
    params = param_fixture(:veteran_lead_premium)
    ActionController::Parameters.new(params)[:form]
  end

  # rubocop:disable Layout/LineLength
  describe '.normalize' do
    it 'normalizes mapped parameters and keeps macthing ones' do
      expect(norm_params).to eq(
        {
          'military_status'=>'Disabled Veteran',
          'marital_status'=>'Married',
          'email'=>'wiggins.charles43@gmail.com',
          'needed_coverage'=>'$25,001 - $50,000',
          'contact_time_of_day'=>'Afternoon',
          'phone'=>'+15308678274',
          'state'=>'California',
          'dob'=>Date.parse(raw_params[:dob]),
          'ip_address'=>'166.198.38.54',
          'utm_source'=>'an',
          'utm_medium'=>'an',
          'utm_campaign'=>'Vet Leads | State Ad Sets | LP\\$25 Target CPL\\35+\\** No SAC ** | 02/26/25',
          'utm_content'=>'CA Dynamic Ad',
          'utm_adset'=>'CA Dynamic Ad Set',
          'utm_site_source'=>'an',
          'user_agent'=>'Mozilla/5.0 (Linux; Android 14; SM-A156U1 Build/UP1A.231005.007; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/133.0.6943.137 Mobile Safari/537.36',
          'utm_owner'=>'RoundRobin',
          'utm_id'=>'120218096375490363',
          'utm_term'=>'120218097907210363',
          'fbclid'=>'IwY2xjawI4LfZleHRuA2FlbQEwAGFkaWQBqxm5IGEf-wEdh-ugy9vvRcUuCCqhlT8iOl2P1B2BUGsWG8qyLMC4zbng2U7PBbvqRrdN_aem_Rao0ymcI8MBsVhgEmEsAGQ',
          'first_name'=>'Charles',
          'full_name'=>'Charles E wiggins',
          'is_dropoff'=>false,
          'last_name'=>'wiggins'
        }
      )
    end

    it 'ignores unmapped and non-model parameters' do
      expect(norm_params).not_to have_key(:ref_id)
    end
  end
  # rubocop:enable Layout/LineLength
end
