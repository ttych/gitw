# frozen_string_literal: true

require_relative 'git_options'
require_relative 'git_option'

module Gitw
  # Repository to provide service around local repository
  class Repository
    def initialize(dir, _options = {})
      @dir = dir

      @git_dir = options[:git_dir] || options['git_dir']
      @worktree_dir = options[:worktree_dir] || options['worktree_dir']
    end

    def self.init(directory = '.', options = {})
      return unless directory

      new(directory, options).init(options)
    end

    def self.clone(from, to = nil, options = {})
      return unless from

      from_url = Gitcmd::URL.new(from)
      to ||= from_url.basename
      new(to, options).clone(from_url, options)
    end

    def self.at(directory = '.', options = {})
      return unless directory

      new(directory, options).valid?
    end
  end
end
