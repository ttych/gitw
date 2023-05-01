# frozen_string_literal: true

require_relative 'gitw/version'
require_relative 'gitw/conf'
require_relative 'gitw/repository'

# namespace for gitw library
# service entrypoint for
# - init
# - clone
# - repository
# - config
# - conf (gitw)
module Gitw
  def self.conf
    @conf ||= Gitw::Conf.new
    yield @conf if block_given?
    @conf
  end
end
