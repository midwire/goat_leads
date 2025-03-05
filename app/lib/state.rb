# frozen_string_literal: true

require_relative 'case_insensitive_hash'

# Simple class to encapsulate a USA State
class State
  LOOKUP_TABLE = {
    'AL' => 'Alabama',
    'AK' => 'Alaska',
    'AZ' => 'Arizona',
    'AR' => 'Arkansas',
    'CA' => 'California',
    'CO' => 'Colorado',
    'CT' => 'Connecticut',
    'DE' => 'Delaware',
    'DC' => 'District Of Columbia',
    'FL' => 'Florida',
    'GA' => 'Georgia',
    'GU' => 'Guam',
    'HI' => 'Hawaii',
    'ID' => 'Idaho',
    'IL' => 'Illinois',
    'IN' => 'Indiana',
    'IA' => 'Iowa',
    'KS' => 'Kansas',
    'KY' => 'Kentucky',
    'LA' => 'Louisiana',
    'ME' => 'Maine',
    'MD' => 'Maryland',
    'MA' => 'Massachusetts',
    'MI' => 'Michigan',
    'MN' => 'Minnesota',
    'MS' => 'Mississippi',
    'MO' => 'Missouri',
    'MT' => 'Montana',
    'NE' => 'Nebraska',
    'NV' => 'Nevada',
    'NH' => 'New Hampshire',
    'NJ' => 'New Jersey',
    'NM' => 'New Mexico',
    'NY' => 'New York',
    'NC' => 'North Carolina',
    'ND' => 'North Dakota',
    'OH' => 'Ohio',
    'OK' => 'Oklahoma',
    'OR' => 'Oregon',
    'PA' => 'Pennsylvania',
    'PR' => 'Puerto Rico',
    'RI' => 'Rhode Island',
    'SC' => 'South Carolina',
    'SD' => 'South Dakota',
    'TN' => 'Tennessee',
    'TX' => 'Texas',
    'UT' => 'Utah',
    'VT' => 'Vermont',
    'VA' => 'Virginia',
    'WA' => 'Washington',
    'WI' => 'Wisconsin',
    'WV' => 'West Virginia',
    'WY' => 'Wyoming'
  }.freeze

  class << self
    def all
      LOOKUP_TABLE.keys
    end

    def code_from_name(state_name)
      return nil if state_name.blank?

      inverted_lookup_table[state_name.strip.downcase]
    end

    def name_from_code(state_code)
      return nil if state_code.blank?

      lookup_table[state_code.strip.downcase]
    end

    def valid_state_code?(state_code)
      return false if state_code.blank?

      lookup_table.keys.include?(state_code.strip.downcase)
    end

    def dropdown_options
      options = { '' => 'Select State' }
      options.merge!(LOOKUP_TABLE)
      options.invert.to_a
    end

    private

    def lookup_table
      @lookup_table ||= begin
        lt = CaseInsensitiveHash.new
        LOOKUP_TABLE.each do |key, value|
          lt[key] = value
        end
        lt
      end
    end

    def inverted_lookup_table
      @inverted_lookup_table ||= begin
        lt = CaseInsensitiveHash.new
        LOOKUP_TABLE.invert.each do |key, value|
          lt[key] = value
        end
        lt
      end
    end
  end
end
