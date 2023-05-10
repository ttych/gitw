# frozen_string_literal: true

require 'gitw/git_exe'
require 'gitw/repository/url'

module Gitw
  # Repository to provide service around local repository
  class Repository
    attr_reader :dir, :git_dir, :worktree_dir

    def initialize(dir, options = {}, git_exe: Gitw::GitExe.new)
      @dir = dir
      @git_exe = git_exe

      @git_dir = options[:git_dir] || options['git_dir']
      @worktree_dir = options[:worktree_dir] || options['worktree_dir']
    end

    def init(options = {})
      git.init!(dir,
                options: options,
                git_options: git_opts_base)

      self
    end

    # git

    def git
      @git_exe
    end

    def git_opts_base
      { git_dir: git_dir,
        work_tree: worktree_dir }
    end

    def git_opts
      git_opts_base.update({ dir: dir })
    end

    # specific builder

    def self.init(directory = '.', options = {})
      return unless directory

      new(directory, options).init(options)
    end

    def self.clone(from, to = nil, options = {})
      return unless from

      from_url = Gitw::Repository::URL.new(from)
      to ||= from_url.basename
      new(to, options).clone(from_url, options)
    end

    def self.at(directory = '.', options = {})
      return unless directory

      new(directory, options).valid?
    end
  end
end
