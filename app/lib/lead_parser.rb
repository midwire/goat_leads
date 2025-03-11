# frozen_string_literal: true

class LeadParser
  attr_reader :params, :lead_base_type

  def initialize(params, lead_base_type)
    @params = params
    @lead_base_type = lead_base_type
  end

  def model_instance
    lead_class.new(lead_params)
  end

  private

  def lead_quality
    return 'Premium' unless params[:lead_quality]

    allowed_values = %w[standard premium]
    return 'Premium' unless allowed_values.include?(params[:lead_quality].downcase)

    params[:lead_quality].titleize
  end

  def video_type
    return 'Other' unless params[:video_type]

    allowed_values = %w[other dom]
    return 'Other' unless allowed_values.include?(params[:video_type].downcase)

    params[:video_type].titleize
  end

  def lead_class
    "#{lead_base_type}_#{lead_quality}".classify.constantize
  end

  def lead_params
    params[:lead_type] = lead_quality
    params[:video_type] = video_type
    normalizer = LeadParamNormalizer.new(params)
    normalizer.normalize
  end
end
