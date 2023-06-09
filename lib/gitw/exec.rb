# frozen_string_literal: true

require 'forwardable'
require 'open3'

module Gitw
  # exec
  class Exec
    def initialize(*commands, **options)
      @commands = commands
      @options = options
    end

    def exec
      # puts "EXEC (#{Dir.pwd})> #{commands} #{options}"
      stdout, stderr, exit_status = Open3.capture3(*commands, **options)

      ExecResult.new(commands: commands,
                     options: options,
                     status: exit_status,
                     stdout: stdout,
                     stderr: stderr)
    rescue StandardError => e
      ExecResult.from_exception(e, commands: commands, options: options)
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

    def raise_on_failure(exception = RuntimeError)
      return if success?

      raise exception, "git exited #{exitstatus}: #{stderr}"
    end

    def self.from_exception(exception, commands: nil, options: nil)
      exception.extend AsAProcessStatus
      new(commands: commands,
          options: options,
          status: exception,
          stdout: nil,
          stderr: "Exception: #{exception}")
    end
  end

  # behavior to simulate
  module AsAProcessStatus
    def exitstatus
      -2
    end

    def success?
      false
    end

    def exited?
      true
    end

    def signaled?
      false
    end

    def pid
      -2
    end
  end
end
