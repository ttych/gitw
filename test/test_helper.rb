# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter %r{^/test/}
  end
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'gitw'

require 'minitest/autorun'

require_relative 'helpers/tmp'
class Minitest::Test # rubocop:disable Style/ClassAndModuleChildren
  include Test::Helpers::Tmp
end
