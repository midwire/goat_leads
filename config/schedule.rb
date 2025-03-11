# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

require 'dotenv/load'
require 'whenever'
require 'rails'
require 'tzinfo'

set :environment, ENV.fetch('RAILS_ENV', 'development') # preferred rails env
env 'MAILTO', 'leadsupport@goatleads.com'

set :output, '/var/www/goat_leads/shared/log/cron.log'

# Mountain Time
# UTC is 6 hrs ahead in summer
# UTC is 7 hrs ahead in winter
# rubocop:disable Rails/TimeZone
def app_time(time_str)
  TZInfo::Timezone.get('America/Denver').local_to_utc(Time.parse(time_str))
end
# rubocop:enable Rails/TimeZone

########################################
# COMMON ALL ENV TASKS

# every(:day, at: app_time('1:00'), roles: [:primary]) do
#   # Assign leads
#   rake 'leads:assign'
# end

every 10.minutes, roles: %i[primary] do
  rake 'leads:assign'
end
