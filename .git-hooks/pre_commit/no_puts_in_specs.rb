# frozen_string_literal: true

module Overcommit::Hook::PreCommit
  class NoPutsInSpecs < Base
    def run
      errors = []

      applicable_files.each do |file|
        if File.read(file).match?(/^\s*puts\(?\s*["'][^"']+["']/m)
          errors << "#{file}: contains a 'puts' statement!`"
        end
      rescue StandardError => e
        errors << "#{file}: exception thrown (#{e})"
      end

      return :fail, errors.join("\n") if errors.any?

      :pass
    end
  end
end
