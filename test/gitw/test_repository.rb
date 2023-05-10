# frozen_string_literal: true

require 'test_helper'

require 'gitw/repository'

# unit test git Gitw::Repository
class TestRepository < Minitest::Test
  def test_instance_with_dir
    repository = Gitw::Repository.new('/tmp/test')

    assert_equal '/tmp/test', repository.dir
  end

  def test_instance_with_default_attributes
    repository = Gitw::Repository.new('/tmp/test_repo')

    assert_equal '/tmp/test_repo', repository.dir
    assert_nil repository.git_dir
    assert_nil repository.worktree_dir
  end

  def test_init_without_options
    in_tmpdir do |tmpdir|
      repository = Gitw::Repository.init(tmpdir)

      assert repository
      assert_equal tmpdir, repository.dir
      assert_nil repository.git_dir
      assert_nil repository.worktree_dir

      assert File.directory?('.git')
    end
  end

  def test_init_in_non_existing_directory
    in_tmpdir do |tmpdir|
      git_dir = File.join(tmpdir, 'init')
      repository = Gitw::Repository.init(git_dir)

      assert repository
      assert_equal git_dir, repository.dir
      assert_nil repository.git_dir
      assert_nil repository.worktree_dir

      assert File.directory?('init/.git')
    end
  end

  def test_init_builder_with_bare_option
    skip('waiting implementation')
  end

  def test_init_builder_with_mirror_option
    skip('waiting implementation')
  end
end
