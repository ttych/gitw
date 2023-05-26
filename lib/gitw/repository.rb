# frozen_string_literal: true

require 'forwardable'

require 'gitw/git_exe'

module Gitw
  # git repository service
  class Repository
    extend Forwardable

    attr_reader :base_dir

    def initialize(base_dir = '.', **options)
      @base_dir = File.expand_path(base_dir)
      @git_dir = options[:git_dir] || options['git_dir']
      @worktree_dir = options[:worktree_dir] || options['worktree_dir']
    end

    def git_dir
      return @git_dir if @git_dir
    end

    def worktree_dir
      return @worktree_dir if @worktree_dir
    end

    def in_repository?
      return false unless File.directory?(base_dir)
      return true if inside_work_tree? || inside_git_dir?

      false
    end

    def inside_work_tree?
      git.is_inside_work_tree
    rescue Gitw::GitError
      false
    end

    def inside_git_dir?
      git.is_inside_git_dir
    rescue Gitw::GitError
      false
    end

    def toplevel
      git.toplevel
    rescue Gitw::GitError
      nil
    end

    def absolute_git_dir
      git.absolute_git_dir
    rescue Gitw::GitError
      nil
    end

    def bare?
      git.is_bare_repository
    rescue Gitw::GitError
      false
    end

    def root_dir
      return absolute_git_dir if bare?

      git.toplevel
    rescue Gitw::GitError
      nil
    end

    def init(**options)
      FileUtils.mkdir_p base_dir
      git.init(base_dir, **options)

      self
    rescue Errno::EACCES, Gitw::GitError
      nil
    end

    def clone_from(url, **options)
      FileUtils.mkdir_p base_dir
      git(git_base_options).clone(url.to_s, base_dir, **options)

      self
    rescue Errno::EACCES, Gitw::GitError
      nil
    end

    def git(options = git_options)
      Dir.chdir(base_dir) do
        Gitw::GitExe.new(options: options)
      end
    end

    def git_options
      git_base_options.merge(
        {
          dir: base_dir
        }
      ).compact
    end

    def git_base_options
      {
        git_dir: git_dir,
        work_tree: worktree_dir
      }.compact
    end

    # def status
    #   @status ||= Repository::Status.new(self)
    # end

    # def remote
    #   @remote ||= Repository::Remote.new(self)
    # end

    # #

    # ADD_OPTIONS = GitOptions.new()

    # def add(*files, **options)
    #   add_options = ADD_OPTIONS.inline(options)

    #   result = gitexec('add', *add_options, '--', *files)
    #   return unless result.success?

    #   self
    # end

    # COMMIT_OPTIONS = GitOptions.new(
    #   GitOption.new(:all, short: :a),
    #   GitOption.new(:message, short: :m, has_argument: true),
    # )

    # def commit(*files, **options)
    #   commit_options = COMMIT_OPTIONS.inline(options)

    #   result = gitexec('commit', *commit_options, '--', *files)
    #   return unless result.success?

    #   self
    # end

    # FETCH_OPTIONS = GitOptions.new(
    #   GitOption.new(:all),
    #   GitOption.new(:tags),
    # )
    # def fetch(repository=nil, refspec=nil, **options)
    #   fetch_options = FETCH_OPTIONS.inline(options)
    #   result = gitexec('fetch', *fetch_options, repository, refspec)
    #   return unless result.success?

    #   self
    # end

    # PULL_OPTIONS = GitOptions.new(
    #   GitOption.new(:all),
    #   GitOption.new(:tags),
    # )
    # def pull(repository=nil, refspec=nil, **options)
    #   pull_options = PULL_OPTIONS.inline(options)
    #   result = gitexec('pull', *pull_options, repository, refspec)
    #   return unless result.success?

    #   self
    # end

    # PUSH_OPTIONS = GitOptions.new(
    #   GitOption.new(:all),
    #   GitOption.new(:mirror),
    #   GitOption.new(:tags),
    # )
    # def push(repository=nil, refspec=nil, **options)
    #   push_options = PUSH_OPTIONS.inline(options)
    #   result = gitexec('push', *push_options, repository, refspec)
    #   return unless result.success?

    #   self
    # end

    def self.at(directory = '.', **options)
      repository = new(directory, **options)
      return nil unless repository.in_repository?

      repository
    end

    def self.init(directory = '.', **options)
      new(directory, **options).init(**options)
    end

    def self.clone(from, to = nil, **options)
      return unless from

      from_url = Gitw::Git::URL.new(from)
      to ||= from_url.basename
      new(to, **options).clone_from(from_url, **options)
    end
  end
end
