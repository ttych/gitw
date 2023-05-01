# frozen_string_literal: true

require 'test_helper'

# unit test
class TestGitw < Minitest::Test
  def setup
    Gitw.instance_variable_set(:@conf, nil)
  end

  def test_it_has_a_version_number
    refute_nil ::Gitw::VERSION
  end

  def test_it_provides_default_gitw_conf
    assert_equal 'git', Gitw.conf.git_path
  end

  def test_it_allows_gitw_conf_through_block
    Gitw.conf do |c|
      c.git_path = '/abc/bin/git'
    end

    assert_equal '/abc/bin/git', Gitw.conf.git_path
  end
end
