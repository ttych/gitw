# frozen_string_literal: true

require 'test_helper'

# unit test
class TestGitw < Minitest::Test
  def test_it_has_a_version_number
    refute_nil ::Gitw::VERSION
  end
end
