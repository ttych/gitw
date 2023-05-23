# frozen_string_literal: true

require 'test_helper'

describe Gitw::Git::RemoteRefs do
  before do
    @origin_ref = Gitw::Git::RemoteRef.new('origin', fetch: 'git@gitlab.com:ttych/gitw.git',
                                                     push: 'git@gitlab.com:ttych/gitw.git')
    @refs = Gitw::Git::RemoteRefs.new([@origin_ref])
  end

  describe '#parse' do
    it 'can parse remote output' do
      remote_output = %(
origin  git@gitlab.com:ttych/gitw.git (fetch)
origin  git@gitlab.com:ttych/gitw.git (push)
)
      refs = Gitw::Git::RemoteRefs.parse(remote_output)

      assert refs
    end
  end

  describe '.by_name' do
    it 'returns the remote ref found by name' do
      ref = @refs.by_name('origin')

      assert ref
      assert_equal 'origin', ref.name
    end

    it 'returns nil if not found by name' do
      refute @refs.by_name('my_ref')
    end
  end

  describe '.by_url' do
    it 'returns the remote ref found by url' do
      refs = @refs.by_url('git@gitlab.com:ttych/gitw.git')

      assert refs
      assert_equal 1, refs.size
      assert_equal 'origin', refs.first.name
    end

    it 'returns nil if not found by url' do
      refute @refs.by_url('git@gitlab.com:test/test.git')
    end
  end
end

describe Gitw::Git::RemoteRef do
  before do
    @ref_fetch_str = 'origin git@gitlab.com:ttych/gitw.git (fetch)'
    @ref_push_str = 'origin git@gitlab.com:ttych/gitw.git (push)'
  end

  describe '#parse' do
    it 'parses fetch entry' do
      ref = Gitw::Git::RemoteRef.parse(@ref_fetch_str)

      assert ref
      assert_equal 'origin', ref.name
    end

    it 'parses push entry' do
      ref = Gitw::Git::RemoteRef.parse(@ref_push_str)

      assert ref
      assert_equal 'origin', ref.name
    end
  end

  describe '.url' do
    it 'returns url from fetch part' do
      @ref = Gitw::Git::RemoteRef.new(
        'remote',
        fetch: 'git@gitlab.com:ttych/gitw.git'
      )

      assert_equal 'git@gitlab.com:ttych/gitw.git', @ref.url
    end

    it 'returns url from push part when no fetch part' do
      @ref = Gitw::Git::RemoteRef.new(
        'remote',
        push: 'https://gitlab.com/ttych/gitw.git'
      )

      assert_equal 'https://gitlab.com/ttych/gitw.git', @ref.url
    end
  end

  describe '.update' do
    it 'allows to update ref with other ref that has same name' do
      @ref1 = Gitw::Git::RemoteRef.new(
        'remote',
        fetch: 'git@gitlab.com:ttych/gitw.git'
      )
      @ref2 = Gitw::Git::RemoteRef.new(
        'remote',
        push: 'https://gitlab.com/ttych/gitw.git'
      )

      @ref1.update(@ref2)

      assert_equal 'remote', @ref1.name
      assert_equal 'git@gitlab.com:ttych/gitw.git', @ref1.fetch
      assert_equal 'https://gitlab.com/ttych/gitw.git', @ref1.push
    end

    it 'does not update ref if other ref has another name' do
      @ref1 = Gitw::Git::RemoteRef.new(
        'remote',
        fetch: 'git@gitlab.com:ttych/gitw.git'
      )
      @ref2 = Gitw::Git::RemoteRef.new(
        'remote2',
        push: 'https://gitlab.com/ttych/gitw.git'
      )

      @ref1.update(@ref2)

      assert_equal 'remote', @ref1.name
      assert_equal 'git@gitlab.com:ttych/gitw.git', @ref1.fetch
      refute @ref1.push
    end
  end
end
