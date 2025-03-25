# frozen_string_literal: true

class LeadParamNormalizer
  # Mapping of webhook keys to model attributes
  PARAMETER_MAPPING = {
    'step_2_-_military_status' => :military_status,
    'step_3_-_marital_status' => :marital_status,
    'step_4_-_how_much_coverage' => :needed_coverage,
    'step_6_-_best_time_to_contact' => :contact_time_of_day
  }.freeze

  # Model attributes that can be used as-is
  DIRECT_ATTRIBUTES = Lead.attribute_names.map(&:to_s).freeze

  def initialize(raw_params)
    @raw_params = raw_params
  end

  def normalize
    permitted_params = @raw_params.permit(*(PARAMETER_MAPPING.keys + DIRECT_ATTRIBUTES))
    normalized = permitted_params.to_h.each_with_object({}) do |(key, value), hash|
      # Check if the key is in the mapping
      if PARAMETER_MAPPING.key?(key)
        model_key = PARAMETER_MAPPING[key]
        hash[model_key] = normalize_value(model_key, value)
      # Check if the key matches a model attribute directly
      elsif DIRECT_ATTRIBUTES.include?(key.to_s)
        hash[key.to_sym] = normalize_value(key.to_sym, value)
        # Ignore any other keys (e.g., extra_field)
      end
    end

    add_defaults(normalized)
    normalized.with_indifferent_access
  end

  private

  def normalize_value(key, value)
    case key
    # when :id
    #   value.to_i # Convert to integer
    when :dob
      Chronic.parse(value) # Convert to Date object
    else
      value # Pass through unchanged for direct matches like name, email
    end
  rescue ArgumentError, TypeError
    value # Fallback to raw value if conversion fails
  end

  def add_defaults(params)
    params[:full_name] ||= make_fullname(params[:first_name], params[:last_name])
    params[:first_name] ||= make_firstname(params[:full_name])
    params[:last_name] ||= make_lastname(params[:full_name])
  end

  def make_fullname(first_name, last_name)
    "#{first_name} #{last_name}"
  end

  def make_firstname(full_name)
    full_name.split.first
  end

  def make_lastname(full_name)
    full_name.split.last
  end
end
