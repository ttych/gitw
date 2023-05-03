# frozen_string_literal: true

require 'test_helper'

require 'gitw/exec'

# unit tests for Gitw::Exec
class TestExec < Minitest::Test
  def test_successful_exec
    result = Gitw::Exec.new(':').exec

    assert_equal 0, result.exitstatus
    assert_predicate result, :success?
    refute_predicate result, :signaled?

    assert_equal [':'], result.commands
  end

  def test_failing_exec
    result = Gitw::Exec.new('/bin/false').exec

    assert_equal 1, result.exitstatus
    refute_predicate result, :success?
    refute_predicate result, :signaled?

    assert_equal ['/bin/false'], result.commands
  end
end
