# frozen_string_literal: true

require_relative '../../app/lib/settings_helper'

Settings.reload_from_files(SettingsHelper.setting_paths)

# Reload settings when config files change without restarting Rails
Rails.application.reloader.to_prepare do
  Settings.reload!
end
