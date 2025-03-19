# frozen_string_literal: true

class LeadParser
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def model_instance
    lead_class.new(lead_params)
  end

  private

  def video_type
    return 'Other' unless params[:video_type]

    allowed_values = %w[other dom]
    return 'Other' unless allowed_values.include?(params[:video_type].downcase)

    params[:video_type].titleize
  end

  def lead_quality
    return 'Premium' unless params[:lead_quality]

    allowed_values = %w[standard premium]
    return 'Premium' unless allowed_values.include?(params[:lead_quality].downcase)

    params[:lead_quality]
  end

  def lead_class
    params[:lead_class].classify.constantize
  end

  def lead_params
    params[:lead_quality] = lead_quality
    params[:video_type] = video_type
    normalizer = LeadParamNormalizer.new(params)
    normalizer.normalize
  end
end
