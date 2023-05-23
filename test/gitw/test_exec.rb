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

  def test_raise_on_failure_on_successful_exec
    result = Gitw::Exec.new(':').exec

    result.raise_on_failure
  end

  def test_failing_exec
    result = Gitw::Exec.new('/bin/false').exec

    assert_equal 1, result.exitstatus
    refute_predicate result, :success?
    refute_predicate result, :signaled?

    assert_equal ['/bin/false'], result.commands
  end

  def test_exec_that_has_exception
    exception = -> { raise 'Error' }
    Open3.stub(:capture3, exception) do
      result = Gitw::Exec.new('/unknown/command').exec

      assert result
      refute_predicate result, :success?
      refute_predicate result, :signaled?
      assert_nil result.stdout
      assert_match(/^Exception:/, result.stderr)
    end
  end

  def test_raise_on_failure_on_failing_exec
    result = Gitw::Exec.new('/bin/false').exec

    assert_raises(RuntimeError) do
      result.raise_on_failure
    end
  end

  def test_raise_on_failure_on_execution_with_exception
    exception = proc { raise 'Error' }
    Open3.stub(:capture3, exception) do
      result = Gitw::Exec.new('/unknown/command').exec

      assert result
      refute_predicate result, :success?
      refute_predicate result, :signaled?
    end
  end

  def test_capture_stdout_on_execution
    result = Gitw::Exec.new('echo test').exec

    assert_equal "test\n", result.stdout
  end

  def test_capture_stderr_on_execution
    result = Gitw::Exec.new('echo test >&2').exec

    assert_equal "test\n", result.stderr
  end
end
