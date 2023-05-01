# frozen_string_literal: true

require 'test_helper'
require 'gitw/conf'

# unit test for Gitcmd::Conf
class TestConf < Minitest::Test
  def test_default_git_path
    conf = Gitw::Conf.new

    assert_equal 'git', conf.git_path
  end

  def test_injected_git_path_through_env
    test_env = { 'GIT_PATH' => '/test/bin/git' }
    conf = Gitw::Conf.new(env: test_env)

    assert_equal '/test/bin/git', conf.git_path
  end

  def test_has_setter_for_git_path
    conf = Gitw::Conf.new

    conf.git_path = '/test/new/path/git'

    assert_equal '/test/new/path/git', conf.git_path
  end
end
