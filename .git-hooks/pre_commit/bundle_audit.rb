# frozen_string_literal: true

module Overcommit::Hook::PreCommit
  # Checks for vulnerable versions of gems in Gemfile.lock.
  # @see https://github.com/rubysec/bundler-audit
  class BundleAudit < Base
    LOCK_FILE = 'Gemfile.lock' unless defined? LOCK_FILE

    def run
      return :pass if skip?

      result = execute(command)
      return :pass if result.success?

      output = [] << (result.stdout + result.stderr)
      [:warn, output]
    end

    def skip?
      cmd = %W[git ls-files -oi --exclude-standard -- #{LOCK_FILE}]
      res = execute(cmd).stdout.split("\n")
      true if res.include?(
        LOCK_FILE
      )
    end
  end
end
