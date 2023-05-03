# frozen_string_literal: true

require_relative 'exec'
require_relative 'git_options'
require_relative 'git_option'

module Gitw
  # git executable
  class GitExe
    DEFAULT_GIT_PATH = 'git'

    attr_reader :git_path

    def initialize(git_path: nil, env: ENV)
      @env = env
      @git_path = git_path || @env['GIT_PATH'] || self.class.git_path
    end

    def exec(*commands, **options)
      Exec.new(git_path, *commands, **options).exec
    end

    class << self
      attr_writer :git_path

      def git_path
        @git_path ||= DEFAULT_GIT_PATH
      end
    end
  end
end
