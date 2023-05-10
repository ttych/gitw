# frozen_string_literal: true

require 'forwardable'
require 'open3'

require_relative 'git_error'

module Gitw
  # exec
  class Exec
    def initialize(*commands, **options)
      @commands = commands
      @options = options
    end

    def exec
      stdout, stderr, exit_status = Open3.capture3(*commands, **options)

      ExecResult.new(commands: commands,
                     options: options,
                     status: exit_status,
                     stdout: stdout,
                     stderr: stderr)
    end

    def commands
      @commands.flatten.compact
    end

    attr_reader :options
  end

  # exec result
  class ExecResult
    extend Forwardable

    def_delegators :@status, :exitstatus, :success?, :exited?, :signaled?, :pid

    attr_reader :commands, :options, :status, :stdout, :stderr

    def initialize(commands:, options:, status:, stdout:, stderr:)
      @commands = commands
      @options = options
      @status = status
      @stdout = stdout
      @stderr = stderr
    end

    def raise_on_failure
      return if success?

      raise Gitw::GitError, "git exited #{exitstatus}: #{stderr}"
    end
  end
end
