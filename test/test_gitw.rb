# frozen_string_literal: true

require 'test_helper'

# unit test
class TestGitw < Minitest::Test
  def teardown
    # reset git_path
    Gitw.git_path = nil
  end

  def test_it_has_a_version_number
    refute_nil ::Gitw::VERSION
  end

  def test_has_shortcut_to_set_git_path
    Gitw.git_path = '/test/bin/git'

    assert_equal '/test/bin/git', Gitw::GitExe.git_path
  end
end
