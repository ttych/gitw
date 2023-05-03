# frozen_string_literal: true

require 'test_helper'

require 'gitw/git_exe'

# unit tests for Gitw::GitExe
class TestGitExe < Minitest::Test
  def teardown
    Gitw::GitExe.git_path = nil
  end

  def test_default_git_path
    git = Gitw::GitExe.new

    assert_equal 'git', git.git_path
  end

  def test_injected_git_path_through_env
    test_env = { 'GIT_PATH' => '/test/bin/git' }
    git = Gitw::GitExe.new(env: test_env)

    assert_equal '/test/bin/git', git.git_path
  end

  def test_set_git_path_
    Gitw::GitExe.git_path = '/test/bin/git'
    git = Gitw::GitExe.new

    assert_equal '/test/bin/git', git.git_path
  end
end
