# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.1'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem 'jsbundling-rails'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'
# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'cssbundling-rails'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Active Model has_secure_password
# [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem 'solid_cache'
# gem 'solid_queue'
gem 'solid_cable'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
# gem 'kamal', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

# Use Active Storage variants
# [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

######################################################################################################
#
gem 'dotenv-rails', '>= 3.1'
gem 'haml-rails', '~> 2.1' # HAML templates
gem 'ajax-datatables-rails', '~> 1.5' # Dynamic datatables
gem 'draper', '~> 4.0' # Decorators
gem 'bootstrap_form', '~> 5.4' # Bootstrap forms
gem 'sidekiq', '~> 7.3' # Background processing jobs
gem 'sidekiq-failures', '~> 1.0' # monitor sidekiq failures
gem 'postmark-rails', '~> 0.22' # Email sending
gem 'sidekiq-unique-jobs', '~> 8.0' # Prevent duplicate sidekiq jobs
gem 'whenever', '~> 1.0', require: false # OOB Task Scheduler
gem 'premailer-rails', '~> 1.12' # Styling for emails
gem 'config', '~> 5.0' # Rails yaml settings
gem 'slack-notifier', '~> 2.4' # Notify slack channels
gem 'exception_notification', github: 'smartinez87/exception_notification', ref: '60e1588'
gem 'google-apis-sheets_v4', '~> 0.39' # Google sheets
gem 'google-apis-drive_v3', '~> 0.62' # To control access to sheets
gem 'money-rails', '~> 1.15' # Deal with money

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  # gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem 'rubocop-rails-omakase', require: false

  gem 'bullet'
  gem 'faker'
  gem 'factory_bot_rails'
  gem 'foreman'
  gem 'pry-nav'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-factory_bot'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubocop-rspec_rails'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem 'rack-mini-profiler'

  gem 'capistrano', '~> 3.1' # Deployment tool
  # gem 'capistrano-nvm', require: false
  gem 'capistrano-passenger', '~> 0.2', require: false # Deployment
  gem 'capistrano-rails', '~> 1.3', require: false # Deployment
  gem 'capistrano-rake', '~> 0.2', require: false # Deployment
  gem 'capistrano-rbenv', '~> 2.1', require: false
  gem 'capistrano-yarn', '~> 2.0', require: false # Deployment

  gem 'annotaterb'
  gem 'bundle-audit'
  gem 'html2haml'
  gem 'rubycritic', require: false
  gem 'traceroute'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
  gem 'rails-controller-testing'
end
