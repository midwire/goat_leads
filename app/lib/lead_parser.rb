# frozen_string_literal: true

class LeadParser
  def initialize(params, lead_base_type)
    @params = params
    @lead_base_type = lead_base_type
  end

  def model_instance
    lead_class(@lead_base_type).new(lead_params)
  end

  private

  def lead_quality
    'Premium'
  end

  def video_type
    'Other'
  end

  def lead_class(lead_base_type)
    "#{lead_base_type}_#{lead_quality}".classify.constantize
  end

  def lead_params
    @params[:lead_type] = lead_quality
    @params[:video_type] = video_type
    normalizer = LeadParamNormalizer.new(@params)
    normalizer.normalize
  end
end
