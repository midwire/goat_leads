# frozen_string_literal: true

namespace :sidekiq do
  task :stop do
    on roles(:app) do
      execute 'sudo /sbin/service sidekiq stop'
    end
  end

  task :start do
    on roles(:app) do
      execute 'sudo /sbin/service sidekiq start'
    end
  end

  task :restart do
    on roles(:app) do
      execute 'sudo /sbin/service sidekiq restart'
    end
  end
end
after 'deploy:check:make_linked_dirs', 'sidekiq:stop'
after 'deploy:symlink:release', 'sidekiq:start'
