# frozen_string_literal: true

require_relative 'gitw/version'
require_relative 'gitw/repository'

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
end
