# frozen_string_literal: true

module Overcommit::Hook::PreCommit
  class NoBindingPry < Base
    def run
      errors = []

      applicable_files.each do |file|
        errors << "#{file}: contains 'binding.pry'`" if File.read(file).match?(/binding\.pry/m)
      rescue StandardError => e
        errors << "#{file}: exception thrown (#{e})"
      end

      return :fail, errors.join("\n") if errors.any?

      :pass
    end
  end
end
