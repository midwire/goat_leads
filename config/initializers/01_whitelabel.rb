# frozen_string_literal: true

class Whitelabel
  DEFAULT_LABEL = 'goatleads'

  class << self
    def labeled?
      label != DEFAULT_LABEL
    end

    def label
      @label ||= Settings.whitelabel.label
    end

    def site_title
      @site_title ||= Settings.whitelabel.site_title
    end

    def site_description
      @site_description ||= Settings.whitelabel.site_desc
    end

    def social_media_description
      @social_media_description ||= Settings.whitelabel.social_desc
    end

    def social_media_title
      @social_media_title ||= Settings.whitelabel.social_title
    end

    def site_domain
      @site_domain ||= Settings.whitelabel.site_domain
    end
  end
end
