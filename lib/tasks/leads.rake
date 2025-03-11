# frozen_string_literal: true

namespace :leads do
  desc 'Queue the AssignLeadsJob'
  task assign: :environment do
    AssignLeadsJob.perform_async
  end
end
