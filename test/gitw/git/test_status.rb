# frozen_string_literal: true

require 'test_helper'

describe Gitw::Git::Status do
  describe '#parse' do
    it 'can parse porcelain status to generate Status' do
      status_output = %(
M  lib/gitw.rb
M  lib/gitw/exec.rb
M  lib/gitw/git_exe.rb
M  lib/gitw/git_opts.rb
)
      status = Gitw::Git::Status.parse(status_output)

      assert status
    end
  end

  describe '.changed?' do
    it 'returns falsy when file is not present' do
      status = Gitw::Git::Status.new([])

      refute status.changed?('unexisting_file')
    end

    it 'returns falsy when file has no change' do
      status = Gitw::Git::Status.new(
        [
          Gitw::Git::StatusFile.new('file1', index_status: 'M', workingtree_status: 'M')
        ]
      )

      refute status.changed?('file2')
    end

    it 'returns truthy when file has index or worktree change' do
      status = Gitw::Git::Status.new(
        [
          Gitw::Git::StatusFile.new('file1', index_status: 'M', workingtree_status: 'M')
        ]
      )

      assert status.changed?('file1')
    end
  end

  describe '.untracked?' do
    it 'returns falsy when file is not present' do
      status = Gitw::Git::Status.new([])

      refute status.untracked?('unexisting_file')
    end

    it 'returns falsy when file is no git tracked' do
      status = Gitw::Git::Status.new(
        [
          Gitw::Git::StatusFile.new('file1', index_status: 'M', workingtree_status: 'M')
        ]
      )

      refute status.untracked?('file1')
    end

    it 'returns truthy when file is git tracked' do
      status = Gitw::Git::Status.new(
        [
          Gitw::Git::StatusFile.new('file1', index_status: '?', workingtree_status: '?')
        ]
      )

      assert status.untracked?('file1')
    end
  end
end

describe Gitw::Git::StatusFile do
  describe '#parse' do
    it 'can parse porcelain status entry to generate StatusFile' do
      status_entry = 'M  lib/gitw.rb'

      status = Gitw::Git::StatusFile.parse(status_entry)

      assert status
    end
  end

  describe '.index_changed?' do
    it 'returns falsy when index is unmodified' do
      status = Gitw::Git::StatusFile.new('file', index_status: ' ', workingtree_status: 'M')

      refute_predicate status, :index_changed?
    end

    it 'returns falsy when index is untracked' do
      status = Gitw::Git::StatusFile.new('file', index_status: '?', workingtree_status: 'M')

      refute_predicate status, :index_changed?
    end

    it 'returns falsy when index is ignored' do
      status = Gitw::Git::StatusFile.new('file', index_status: '!', workingtree_status: 'M')

      refute_predicate status, :index_changed?
    end

    it 'returns truthy when index is modified' do
      status = Gitw::Git::StatusFile.new('file', index_status: 'M', workingtree_status: 'M')

      assert_predicate status, :index_changed?
    end
  end

  describe '.workingtree_changed?' do
    it 'returns falsy when workingtree is unmodified' do
      status = Gitw::Git::StatusFile.new('file', index_status: 'M', workingtree_status: ' ')

      refute_predicate status, :workingtree_changed?
    end

    it 'returns falsy when workingtree is untracked' do
      status = Gitw::Git::StatusFile.new('file', index_status: 'M', workingtree_status: '?')

      refute_predicate status, :workingtree_changed?
    end

    it 'returns falsy when workingtree is ignored' do
      status = Gitw::Git::StatusFile.new('file', index_status: 'M', workingtree_status: '!')

      refute_predicate status, :workingtree_changed?
    end

    it 'returns truthy when workingtree is modified' do
      status = Gitw::Git::StatusFile.new('file', index_status: 'M', workingtree_status: 'M')

      assert_predicate status, :workingtree_changed?
    end
  end

  describe '.untracked?' do
    it 'returns truthy when index is untracked' do
      status = Gitw::Git::StatusFile.new('file', index_status: '?', workingtree_status: 'M')

      assert_predicate status, :untracked?
    end

    it 'returns truthy when workingtree is untracked' do
      status = Gitw::Git::StatusFile.new('file', index_status: 'M', workingtree_status: '?')

      assert_predicate status, :untracked?
    end

    it 'returns false when index and workingtree are modified' do
      status = Gitw::Git::StatusFile.new('file', index_status: 'M', workingtree_status: 'M')

      refute_predicate status, :untracked?
    end
  end
end
