# frozen_string_literal: true

require_relative 'exec'
require_relative 'git_error'
require_relative 'git_opts'
require_relative 'git/status'
require_relative 'git/remote_ref'

# rubocop:disable Metrics/ClassLength, Metrics/MethodLength, Naming/PredicateName
module Gitw
  # git executable wrapper
  class GitExe
    def initialize(options: nil, git_bin: nil, env: ENV)
      @options = options
      @git_bin = git_bin
      @env = env
    end

    def git_bin
      @git_bin || @env['GIT_BIN'] || self.class.git_bin
    end

    def exec(*cmds, **opts)
      result = Exec.new(git_bin, *cmds, **opts).exec
      result.raise_on_failure(Gitw::GitError)
      result.stdout
    rescue StandardError => e
      raise Gitw::GitError, e.to_s
    end

    def git_opts(options = nil)
      GitOpts.new
             .allow(:c, short: '-c', with_arg: true, multiple: true)
             .allow(:git_dir, long: '--git-dir', with_arg: true)
             .allow(:work_tree, long: '--work-tree', with_arg: true)
             .allow(:dir, short: '-C', with_arg: true)
             .allow(:version, short: '-v', long: '--version')
             .add(:c, 'core.quotePath=true')
             .add(:c, 'color.ui=false')
             .from(@options)
             .from(options)
    end

    # version

    def version
      version_git_opts = git_opts.add(:version)
      version = exec(*version_git_opts)
      version.strip
    rescue StandardError
      nil
    end

    # init

    def init_opts(options = nil)
      GitOpts.new
             .allow(:quiet, short: '-q', long: '--quiet')
             .allow(:bare, long: '--bare')
             .allow(:init_branch, short: '-b', with_arg: true)
             .from(@options)
             .from(options)
    end

    def init(*args, git_options: nil, **options)
      init_git_options = git_opts(git_options)
      init_options = init_opts(options)
      exec(*init_git_options, 'init', *init_options, *args)
    end

    # clone

    def clone_opts(options = nil)
      GitOpts.new
             .allow(:verbose, short: '-v', long: '--verbose')
             .allow(:quiet, short: '-q', long: '--quiet')
             .allow(:no_checkout, long: '--no-checkout')
             .allow(:bare, long: '--bare')
             .allow(:mirror, long: '--mirror')
             .allow(:depth, long: '--depth', with_arg: true)
             .from(@options)
             .from(options)
    end

    def clone(from, to, git_options: nil, **options)
      clone_git_options = git_opts(git_options)
      clone_options = clone_opts(options)
      exec(*clone_git_options, 'clone', *clone_options, from, to)
    end

    # rev-parse

    def rev_parse_opts(options = nil)
      GitOpts.new
             .allow(:git_dir, long: '--git-dir')
             .allow(:git_common_dir, long: '--git-common-dir')
             .allow(:show_toplevel, long: '--show-toplevel')
             .allow(:absolute_git_dir, long: '--absolute-git-dir')
             .allow(:is_inside_git_dir, long: '--is-inside-git-dir')
             .allow(:is_inside_work_tree, long: '--is-inside-work-tree')
             .allow(:is_bare_repository, long: '--is-bare-repository')
             .allow(:is_shallow_repository, long: '--is-shallow-repository')
             .from(@options)
             .from(options)
    end

    def rev_parse(*args, git_options: nil, **options)
      rev_parse_git_options = git_opts(git_options)
      rev_parse_options = rev_parse_opts(options)
      exec(*rev_parse_git_options, 'rev-parse', *rev_parse_options, *args)
    end

    def git_dir(git_options: nil)
      git_dir = rev_parse(git_options: git_options, git_dir: nil)
      git_dir.strip
    end

    def toplevel(git_options: nil)
      git_dir = rev_parse(git_options: git_options, show_toplevel: nil)
      git_dir.strip
    end

    def is_inside_git_dir(git_options: nil)
      status = rev_parse(git_options: git_options, is_inside_git_dir: nil)
      status.strip.downcase == 'true'
    end

    def is_inside_work_tree(git_options: nil)
      status = rev_parse(git_options: git_options, is_inside_work_tree: nil)
      status.strip.downcase == 'true'
    end

    def is_bare_repository(git_options: nil)
      status = rev_parse(git_options: git_options, is_bare_repository: nil)
      status.strip.downcase == 'true'
    end

    def is_shallow_repository(git_options: nil)
      status = rev_parse(git_options: git_options, is_shallow_repository: nil)
      status.strip.downcase == 'true'
    end

    # status

    def status_opts(options = nil)
      GitOpts.new
             .allow(:porcelain, long: '--porcelain')
             .from(@options)
             .from(options)
    end

    def status(*args, git_options: nil, **options)
      status_git_options = git_opts(git_options)
      status_options = status_opts(options)
      exec(*status_git_options, 'status', *status_options, *args)
    end

    def status_obj(*args, git_options: nil, **options)
      Git::Status.parse(status(*args, git_options: git_options, **options.merge(porcelain: true)))
    end

    # add

    def add_opts(options = nil)
      GitOpts.new
             .from(@options)
             .from(options)
    end

    def add(*files, git_options: nil, **options)
      add_git_options = git_opts(git_options)
      add_options = add_opts(options)

      exec(*add_git_options, 'add', *add_options, *files)
    end

    # commit

    def commit_opts(options = nil)
      GitOpts.new
             .allow(:all, short: '-a')
             .allow(:message, short: '-m', long: '--message', with_arg: true)
             .from(@options)
             .from(options)
    end

    def commit(*args, git_options: nil, **options)
      commit_git_options = git_opts(git_options)
      commit_options = commit_opts(options)

      exec(*commit_git_options, 'commit', *commit_options, *args)
    end

    # fetch

    def fetch_opts(options = nil)
      GitOpts.new
             .allow(:all, long: '--all')
             .allow(:tags, short: '-t', long: '--tags')
             .from(@options)
             .from(options)
    end

    def fetch(*args, git_options: nil, **options)
      fetch_git_options = git_opts(git_options)
      fetch_options = fetch_opts(options)

      exec(*fetch_git_options, 'fetch', *fetch_options, *args)
    end

    # pull

    def pull_opts(options = nil)
      GitOpts.new
             .allow(:all, long: '--all')
             .allow(:tags, short: '-t', long: '--tags')
             .from(@options)
             .from(options)
    end

    def pull(*args, git_options: nil, **options)
      pull_git_options = git_opts(git_options)
      pull_options = pull_opts(options)

      exec(*pull_git_options, 'pull', *pull_options, *args)
    end

    # push

    def push_opts(options = nil)
      GitOpts.new
             .allow(:all, long: '--all')
             .allow(:mirror, long: '--mirror')
             .allow(:tags, long: '--tags')
             .from(@options)
             .from(options)
    end

    def push(*args, git_options: nil, **options)
      push_git_options = git_opts(git_options)
      push_options = push_opts(options)

      exec(*push_git_options, 'push', *push_options, *args)
    end

    # remote

    def remote_opts(options = nil)
      GitOpts.new
             .allow(:verbose, short: '-v')
             .from(@options)
             .from(options)
    end

    def remote(*args, git_options: nil, **options)
      remote_git_options = git_opts(git_options)
      remote_options = remote_opts(options)

      exec(*remote_git_options, 'remote', *remote_options, *args)
    end

    def remotes(git_options: nil)
      Git::RemoteRefs.parse(remote(git_options: git_options, verbose: true))
    end

    # git_bin

    DEFAULT_GIT_BIN = 'git'

    class << self
      attr_writer :git_bin

      def git_bin
        @git_bin ||= DEFAULT_GIT_BIN
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength, Metrics/MethodLength, Naming/PredicateName
