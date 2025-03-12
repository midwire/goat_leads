# frozen_string_literal: true

class SettingsHelper
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.setting_paths
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    [].tap do |a|
      a << Rails.root.join('config/settings.yml')

      if Rails.env.local?
        whitelabel = Rails.application.whitelabel.presence
        a << Rails.root.join('config/settings/local.yml')
        a << Rails.root.join('config', 'settings', "#{Rails.env}.yml")
        if whitelabel
          a << Rails.root.join('config', 'settings', "#{whitelabel}.yml")
          a << Rails.root.join('config', 'settings', whitelabel, "#{Rails.env}.yml")
        end
      else
        # will produce things like ["arizona", "staging"]
        configs = Rails.env.split('_').reject { |s| s == 'deployment' }

        # this will be `staging.yml` for "Demo"
        if configs.length == 1
          a << Rails.root.join('config', 'settings', "#{configs.first}.yml")
        else
          a << Rails.root.join('config', 'settings', "#{configs.last}.yml")
          a << Rails.root.join('config', 'settings', "#{configs.first}.yml")
          a << Rails.root.join('config', 'settings', configs.first, "#{configs.last}.yml")
        end
      end
    end
  end
end
