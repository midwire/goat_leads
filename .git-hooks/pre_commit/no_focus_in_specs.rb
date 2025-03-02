# frozen_string_literal: true

module Overcommit::Hook::PreCommit
  class NoFocusInSpecs < Base
    FOCUS_STRINGS = [
      ', :focus',
      ', focus: true',
      ', :focus => true',
      ', "focus" => true',
      ", 'focus' => true"
    ].freeze

    def run
      errors = []
      files = applicable_files.reject { |f| f == __FILE__ }
      files.each do |file|
        md = File.read(file).match(/(#{FOCUS_STRINGS.join('|')})/m)
        errors << "#{file}: contains '#{md[1]}'" if md
      rescue StandardError => e
        errors << "#{file}: exception thrown (#{e})"
      end

      return :fail, errors.join("\n") if errors.any?

      :pass
    end
  end
end
