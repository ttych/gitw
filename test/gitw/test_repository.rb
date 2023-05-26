# frozen_string_literal: true

require 'test_helper'

require 'gitw/repository'

describe Gitw::Repository do
  describe '#at' do
    it 'returns a repository when is a valid repository' do
      in_tmpdir do |tmpdir|
        `git init`
        repository = Gitw::Repository.at(tmpdir)

        assert repository
        assert_equal tmpdir, repository.base_dir
      end
    end

    it 'returns nil when not in a valid directory' do
      refute Gitw::Repository.at('/test/repository')
    end

    it 'returns nil when not a valid repository' do
      in_tmpdir do |tmpdir|
        refute Gitw::Repository.at(tmpdir)
      end
    end
  end

  describe '#init' do
    it 'returns an initialized repository' do
      in_tmpdir do |tmpdir|
        repository = Gitw::Repository.init(tmpdir)

        assert repository
        assert_equal tmpdir, repository.base_dir
        assert_predicate repository, :in_repository?
      end
    end

    it 'returns nil when cannot create the repository directory' do
      repository = Gitw::Repository.init('/test/non_existing_repository/')

      refute repository
    end

    it 'init the repository at the location even if already in a repository' do
      in_tmpdir do |tmpdir|
        `git init`

        repository = Gitw::Repository.init(File.join(tmpdir, 'sub'))

        assert repository
        assert_equal File.join(tmpdir, 'sub'), repository.base_dir
        assert_predicate repository, :in_repository?
      end
    end
  end

  describe '#clone' do
    it 'returns the cloned repository' do
      in_tmpdir do |tmpdir|
        `git init a`

        repository = Gitw::Repository.clone('a', 'b')

        assert repository
        assert_equal File.join(tmpdir, 'b'), repository.base_dir
        assert_predicate repository, :in_repository?
      end
    end

    it 'returns nil on unexisting source' do
      repository = Gitw::Repository.clone(nil)

      refute repository
    end

    it 'returns nil if the target repository directory is not accessible' do
      in_tmpdir do |_tmpdir|
        `git init a`

        repository = Gitw::Repository.clone('a', '/test/non_existing_repository')

        refute repository
      end
    end
  end

  describe '.inside_work_tree?' do
    it 'returns true if inside repository work tree' do
      in_tmpdir do |_tmpdir|
        `git init`

        repository = Gitw::Repository.at('.')

        assert_predicate repository, :inside_work_tree?
      end
    end

    it 'returns false if in git dir' do
      in_tmpdir do |_tmpdir|
        `git init`

        Dir.chdir('.git') do
          repository = Gitw::Repository.at('.')

          refute_predicate repository, :inside_work_tree?
        end
      end
    end

    it 'returns false if not inside a repository' do
      in_tmpdir do |_tmpdir|
        repository = Gitw::Repository.new('.')

        refute_predicate repository, :inside_work_tree?
      end
    end
  end

  describe '.inside_git_dir?' do
    it 'returns true if inside git dir' do
      in_tmpdir do |_tmpdir|
        `git init`

        Dir.chdir('.git') do
          repository = Gitw::Repository.new('.')

          assert_predicate repository, :inside_git_dir?
        end
      end
    end

    it 'returns false if inside repository work tree' do
      in_tmpdir do |_tmpdir|
        `git init`

        repository = Gitw::Repository.new('.')

        refute_predicate repository, :inside_git_dir?
      end
    end

    it 'returns false if not inside a repository' do
      in_tmpdir do |_tmpdir|
        repository = Gitw::Repository.new('.')

        refute_predicate repository, :inside_git_dir?
      end
    end
  end

  describe '.in_repository?' do
    it 'returns true if inside bare repository' do
      in_tmpdir do |_tmpdir|
        `git init --bare`

        repository = Gitw::Repository.new('.')

        assert_predicate repository, :in_repository?
      end
    end

    it 'returns true if inside repository work tree' do
      in_tmpdir do |_tmpdir|
        `git init`

        repository = Gitw::Repository.new('.')

        assert_predicate repository, :in_repository?
      end
    end

    it 'returns false if not inside a repository' do
      in_tmpdir do |_tmpdir|
        repository = Gitw::Repository.new('.')

        refute_predicate repository, :in_repository?
      end
    end
  end

  describe '.root_dir' do
    it 'returns toplevel directory of a repository' do
      in_tmpdir do |tmpdir|
        `git init`
        FileUtils.mkdir_p 'a/b/c'

        repository = Gitw::Repository.new('a/b/c')

        assert_equal tmpdir, repository.root_dir
      end
    end

    it 'returns absolute git directory for a bare repository' do
      in_tmpdir do |tmpdir|
        `git init --bare`

        repository = Gitw::Repository.new('objects')

        assert_equal tmpdir, repository.root_dir
      end
    end

    it 'returns nil if not inside a repository' do
      in_tmpdir do |_tmpdir|
        FileUtils.mkdir_p 'a/b/c'

        repository = Gitw::Repository.new('a/b/c')

        refute repository.root_dir
      end
    end
  end

  describe '.bare?' do
    it 'returns false in standard repository' do
      in_tmpdir do |_tmpdir|
        `git init`

        repository = Gitw::Repository.new('.')

        refute_predicate repository, :bare?
      end
    end

    it 'returns true in bare repository' do
      in_tmpdir do |_tmpdir|
        `git init --bare`

        repository = Gitw::Repository.new('.')

        assert_predicate repository, :bare?
      end
    end

    it 'returns false when not in a repository' do
      in_tmpdir do |_tmpdir|
        repository = Gitw::Repository.new('.')

        refute_predicate repository, :bare?
      end
    end
  end
end
