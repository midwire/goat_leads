# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq-unique-jobs'

Sidekiq.configure_server do |config|
  config.redis = {
    url: 'redis://127.0.0.1:6379/1'
  }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  SidekiqUniqueJobs::Server.configure(config)
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: 'redis://127.0.0.1:6379/1'
  }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end

SidekiqUniqueJobs.config.lock_info = true
SidekiqUniqueJobs.configure do |config|
  config.enabled = !Rails.env.test?
  config.logger_enabled = !Rails.env.test?
end
