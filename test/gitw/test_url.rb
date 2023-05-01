# frozen_string_literal: true

require 'test_helper'

# unit test for Gitw::URL
# class TestUrl < Minitest::Test
#   def test_instance_on_https_url
#     https_url = 'https://github.com/rubocop/rubocop.git'
#     url = Gitw::URL.new(https_url)

#     assert_equal https_url, url.url
#     assert_nil url.user
#     assert_equal 'github.com', url.host
#     assert_equal 'rubocop/rubocop', url.path
#     assert_equal 'rubocop', url.path_dirname
#     assert_equal 'rubocop', url.path_basename
#   end

#   def test_instance_on_ssh_url
#     ssh_url = 'git@github.com:rubocop/rubocop.git'
#     url = Gitw::URL.new(ssh_url)

#     assert_equal ssh_url, url.url
#     assert_equal 'git', url.user
#     assert_equal 'github.com', url.host
#     assert_equal 'rubocop/rubocop', url.path
#     assert_equal 'rubocop', url.path_dirname
#     assert_equal 'rubocop', url.path_basename
#   end

#   def test_instance_on_short_ssh_url
#     ssh_url = 'github.com:rubocop'
#     url = Gitw::URL.new(ssh_url)

#     assert_equal ssh_url, url.url
#     assert_nil url.user
#     assert_equal 'github.com', url.host
#     assert_equal 'rubocop', url.path
#     assert_equal '.', url.path_dirname
#     assert_equal 'rubocop', url.path_basename
#   end

#   def test_instance_on_absolute_path
#     path_url = '/repositories/github.com/rubocop/rubocop.git'
#     url = Gitw::URL.new(path_url)

#     assert_equal path_url, url.url
#     assert_nil url.user
#     assert_nil url.host
#     assert_equal 'repositories/github.com/rubocop/rubocop', url.path
#     assert_equal 'repositories/github.com/rubocop', url.path_dirname
#     assert_equal 'rubocop', url.path_basename
#   end

#   def test_instance_on_relative_path
#     path_url = 'repositories/github.com/rubocop/rubocop.git'
#     url = Gitw::URL.new(path_url)

#     assert_equal path_url, url.url
#     assert_nil url.user
#     assert_nil url.host
#     assert_equal 'repositories/github.com/rubocop/rubocop', url.path
#     assert_equal 'repositories/github.com/rubocop', url.path_dirname
#     assert_equal 'rubocop', url.path_basename
#   end
# end
