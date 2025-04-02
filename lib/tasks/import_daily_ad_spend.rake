# frozen_string_literal: true

require 'csv'

namespace :ad_spend_csv do
  desc 'Import daily ad spend csv file'
  task :import, [:file] => :environment do |_t, args|
    @date = nil
    CSV.foreach(args[:file], headers: true) do |row|
      col = 0
      row.each_entry do |key, value|
        col += 1
        if key == 'Date'
          @date = Chronic.parse(value) if key == 'Date'
          puts(">>> Processing #{@date}")
          break if @date > Date.current
        else
          break if col > 28

          next if key.blank?

          data = parse_header(key)
          create_summary(@date, data, value)
        end
      end
    end
  end

  private

  def create_summary(date, data, ad_spend)
    ActiveRecord::Base.transaction do
      summary = AdDailySpendSummary.find_by(
        date: date,
        lead_type: data[:lead_type],
        platform: data[:platform],
        campaign: data[:campaign]
      )
      return summary if summary.present?

      summary = AdDailySpendSummary.create(
        date: date,
        lead_type: data[:lead_type],
        platform: data[:platform],
        campaign: data[:campaign],
        ad_spend: normalize_decimal(ad_spend)
      )
      summary
    end
  end

  def normalize_decimal(value)
    return 0.0 if value.blank?

    value.gsub(/[$,]/, '').to_d
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def parse_header(header)
    lead_types = {
      'vet' => 'VeteranLeadPremium',
      'fex' => 'FinalExpenseLeadPremium',
      'mp' => 'MortgageProtectionLeadPremium',
      'iul' => 'IndexUniversalLifeLeadPremium',
      'annuity' => 'AnnuityLeadPremium' # Added based on last example
    }

    platforms = {
      'fb' => 'Facebook',
      'google' => 'Google',
      'tiktok' => 'TikTok'
    }

    # Convert input to lowercase for case-insensitive matching
    str = header.downcase
    result = { platform: nil, campaign: nil, lead_type: nil }

    # Identify lead type
    lead_types.each do |key, value|
      next unless str.include?(key)

      result[:lead_type] = value
      # Remove lead type from string (considering word boundaries)
      str.gsub!(/\b#{key}\b/, '')
      break
    end

    # Identify platform
    platforms.each do |key, value|
      next unless str.include?(key)

      result[:platform] = value
      # Remove platform and any following text
      str.gsub!(/#{key}/, '')
      break
    end

    # Clean up the remaining string for campaign
    campaign = str
        .gsub('leads', '')          # Remove 'leads'
        .gsub('daily spend', '')    # Remove 'daily spend'
        .gsub(/\(\s*\)/, '')       # Remove empty parentheses
        .gsub(/\s+/, ' ')          # Normalize whitespace
        .gsub(%r{[()]}, '')
        .strip                     # Remove leading/trailing whitespace

    result[:campaign] = campaign.empty? ? nil : campaign

    result
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
