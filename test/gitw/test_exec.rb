# frozen_string_literal: true

require 'test_helper'
# require 'gitcmd/exec'

# # unit test for Gitcmd::GitCommand
# class TestExec < Minitest::Test
#   def test_exec_with_std_ruby_scenario
#     cmd = ['ruby', '-e', 'print "o"; STDOUT.flush; STDERR.print "e"']
#     exec_output = Gitcmd::Exec.new(*cmd).exec

#     assert_equal 'o', exec_output.stdout
#     assert_equal 'e', exec_output.stderr
#     assert_predicate exec_output.status, :success?
#   end
# end

# # unit test for Gitcmd::GitOutput
# class TestExecOutput < Minitest::Test
#   def test_instance_base_accessor
#     exec_output = Gitcmd::ExecOutput.new(
#       status: :status,
#       stdout: :stdout,
#       stderr: :stderr
#     )

#     assert_equal :status, exec_output.status
#     assert_equal :stdout, exec_output.stdout
#     assert_equal :stderr, exec_output.stderr
#   end
# end
