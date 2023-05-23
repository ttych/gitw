# frozen_string_literal: true

require_relative 'gitw/version'
require_relative 'gitw/repository'
require_relative 'gitw/git_exe'

# namespace for gitw library
# service entrypoint for
# - init
# - clone
# - repository
module Gitw
  def self.init(dir = '.', **options)
    Gitw::Repository.init(dir, **options)
  end

  def self.clone(from, to = nil, **options)
    Gitw::Repository.clone(from, to, **options)
  end

  def self.repository(directory, **options)
    Gitw::Repository.at(directory, **options)
  end

  def self.git_bin=(git_bin)
    Gitw::GitExe.git_bin = git_bin
  end
end
