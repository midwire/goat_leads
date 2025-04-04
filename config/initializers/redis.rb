# frozen_string_literal: true

require 'fakeredis' if Rails.env.test? || ENV['DISABLE_REDIS']

Rails.application.config.cache_store = :redis_cache_store, {
  url: 'redis://127.0.0.1:6379/1'
}

# Turn on rate-limiting if enabled
# Rack::Attack.cache.store = Rails.cache

Rails.cache = ActiveSupport::Cache.lookup_store(Rails.application.config.cache_store)
