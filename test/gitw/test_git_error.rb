# frozen_string_literal: true

require 'test_helper'

require 'gitw/git_error'

# unit test for Gitw:GitError
class TestGitError < Minitest::Test
  def test_git_error_can_be_raised
    assert_raises(Gitw::GitError) do
      raise Gitw::GitError, 'git error ....'
    end
  end
end
