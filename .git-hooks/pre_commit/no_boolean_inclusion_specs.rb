# frozen_string_literal: true

module Overcommit::Hook::PreCommit
  class NoBooleanInclusionSpecs < Base
    def run
      errors = []

      applicable_files.each do |file|
        if File.read(file).match?(/in_array\(\s*\[\s*true,\s*false\s*\]\s*\)/m)
          errors << "#{file}: contains a 'in_array[true, false]' statement for a bool column!`"
        end
      rescue StandardError => e
        errors << "#{file}: exception thrown (#{e})"
      end

      return :fail, errors.join("\n") if errors.any?

      :pass
    end
  end
end
