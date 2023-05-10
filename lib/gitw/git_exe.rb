# frozen_string_literal: true

require_relative 'exec'
require_relative 'git_opts'

module Gitw
  # git executable
  class GitExe
    DEFAULT_GIT_PATH = 'git'

    def initialize(git_path: nil, env: ENV)
      @git_path = git_path
      @env = env
    end

    def exec(*cmds, **opts)
      Exec.new(git_path, *cmds, **opts).exec
    end

    def git_path
      @git_path || @env['GIT_PATH'] || self.class.git_path
    end

    def git_opts(options = nil)
      GitOpts.new
             .allow(:version, short: '-v', long: '--version')
             .allow(:c, short: '-c', with_arg: true, multiple: true)
             .allow(:dir, short: '-C', with_arg: true)
             .allow(:git_dir, long: '--git-dir', with_arg: true)
             .allow(:work_tree, long: '--work-tree', with_arg: true)
             .add(:c, 'core.quotePath=true')
             .add(:c, 'color.ui=false')
             .from(options)
    end

    # version

    def version(git_options: nil)
      version_git_options = git_opts(git_options).add(:version)

      result = exec(*version_git_options.opts)
      result.raise_on_failure
      result.stdout.strip
    end

    # init

    def init_opts(options = nil)
      GitOpts.new
             .allow(:quiet, short: '-q', long: '--quiet')
             .allow(:bare, long: '--bare')
             .allow(:init_branch, short: '-b', with_arg: true)
             .from(options)
    end

    def init(*args, git_options: nil, options: nil)
      init_git_options = git_opts(git_options)
      init_options = init_opts(options)
      exec(*init_git_options.opts, 'init', *init_options.opts, *args)
    end

    def init!(*args, git_options: nil, options: nil)
      result = init(*args, git_options: git_options, options: options)
      result.raise_on_failure
      result
    end

    # status
    # https://git-scm.com/docs/git-status

    class << self
      attr_writer :git_path

      def git_path
        @git_path ||= DEFAULT_GIT_PATH
      end
    end
  end
end
