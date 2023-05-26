# frozen_string_literal: true

require 'test_helper'

require 'gitw/git/url'

describe Gitw::Git::URL do
  before do
    @local_url = '/git/local/url'
    @ssh_url = 'git@gitlab.com:orga/repo.git'
    @http_url = 'https://gitlab.com/orga/repo.git'
  end

  describe 'instantiation' do
    it 'can encapsulate a local url' do
      url = Gitw::Git::URL.new(@local_url)

      assert_equal @local_url, url.to_s
    end

    it 'can encapsulate a ssh url' do
      url = Gitw::Git::URL.new(@ssh_url)

      assert_equal @ssh_url, url.to_s
    end

    it 'can encapsulate a http url' do
      url = Gitw::Git::URL.new(@http_url)

      assert_equal @http_url, url.to_s
    end
  end

  describe '.path_dirname' do
    it 'extract path dirname for a local url' do
      url = Gitw::Git::URL.new(@local_url)

      assert_equal 'git/local', url.path_dirname
    end

    it 'extract path dirname for a ssh url' do
      url = Gitw::Git::URL.new(@ssh_url)

      assert_equal 'orga', url.path_dirname
    end

    it 'extract path dirname for a http url' do
      url = Gitw::Git::URL.new(@http_url)

      assert_equal 'orga', url.path_dirname
    end
  end

  describe '.path_basename' do
    it 'extract path basename for a local url' do
      url = Gitw::Git::URL.new(@local_url)

      assert_equal 'url', url.path_basename
    end

    it 'extract path basename for a ssh url' do
      url = Gitw::Git::URL.new(@ssh_url)

      assert_equal 'repo', url.path_basename
    end

    it 'extract path basename for a http url' do
      url = Gitw::Git::URL.new(@http_url)

      assert_equal 'repo', url.path_basename
    end
  end
end
