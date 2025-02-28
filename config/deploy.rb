# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.19.2'

set :application, 'goat_leads'
set :repo_url, 'git@github.com:midwire/goat_leads.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# RBENV
set :rbenv_type, :system # or :system, depends on your rbenv setup
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_roles, :all # default value

# YARN
# set :yarn_target_path, -> { release_path.join('subdir') } # default not set
set :yarn_flags, '--production --silent --no-progress'
set :yarn_roles, :all                                     # default
set :yarn_env_variables, {}                               # default

# NVM
set :nvm_type, :user # or :system, depends on your nvm setup
set :nvm_node, 'v18.17.1'
set :nvm_map_bins, %w[node npm yarn]

# Whenever / crontab integration
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_roles, -> { %i[primary app] }

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'
append :linked_files, 'config/database.yml', '.env', 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'config/credentials'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :default_env, { path: '/home/deploy/.yarn/bin:/home/deploy.nvm/versions/node/v18.17.1/bin:$PATH' }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

after 'deploy:updated', 'assets:compile'
namespace :assets do
  task :compile do
    on roles(:app) do
      execute <<-SCRIPT
        export PATH="$PATH:/home/deploy/.nvm/versions/node/v18.17.1/bin:/opt/rbenv/shims"
        export RAILS_ENV=#{fetch(:rails_env)}
        cd #{release_path}
        bundle exec rake assets:clobber
        bundle exec rake assets:precompile
      SCRIPT
    end
  end
end
