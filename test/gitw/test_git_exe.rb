# frozen_string_literal: true

require 'test_helper'

require 'gitw/git_exe'

# unit tests for Gitw::GitExe
describe Gitw::GitExe do
  before do
    @git = Gitw::GitExe.new
  end

  after do
    Gitw::GitExe.git_bin = nil
  end

  describe '#git_bin' do
    it 'has git as the default git_bin' do
      assert_equal 'git', @git.git_bin
    end

    it 'has setter for git_bin' do
      Gitw::GitExe.git_bin = '/test/bin/git'
      git = Gitw::GitExe.new

      assert_equal '/test/bin/git', git.git_bin
    end

    it 'can fetch git_bin from env' do
      test_env = { 'GIT_BIN' => '/test_env/bin/git' }
      git = Gitw::GitExe.new(env: test_env)

      assert_equal '/test_env/bin/git', git.git_bin
    end
  end

  describe '.version' do
    it 'returns version string' do
      assert @git.version
      assert_match(/^git version /, @git.version)
    end

    it 'returns nil on execution failure' do
      git = Gitw::GitExe.new(git_bin: '/test/bin/git')

      assert_nil git.version
    end
  end

  describe '.init' do
    it 'init repository' do
      in_tmpdir do |tmpdir|
        @git.init(tmpdir)

        assert File.directory?(File.join(tmpdir, '.git'))
      end
    end

    it 'init repository with bare option' do
      in_tmpdir do |tmpdir|
        @git.init(tmpdir, bare: true)

        assert_path_exists(File.join(tmpdir, 'HEAD'))
      end
    end

    it 'raises exception on init failure' do
      assert_raises(Gitw::GitError) do
        @git.init('/non/existing/path')
      end
    end
  end

  describe '.clone' do
    it 'clone repository' do
      in_tmpdir do
        `git init a`
        @git.clone('a', 'b')

        assert_path_exists(File.join('b', '.git'))
      end
    end

    it 'clone with bare option' do
      in_tmpdir do
        `git init a`
        @git.clone('a', 'b', bare: true)

        assert_path_exists(File.join('b', 'HEAD'))
      end
    end

    it 'raises exception on clone with missing source' do
      assert_raises(Gitw::GitError) do
        @git.clone('/non/existing/path1', '/non/existing/path2')
      end
    end
  end

  describe '.add' do
    it 'add files do index' do
      in_tmpdir do
        `git init`
        `touch README.md`

        @git.add('README.md')

        assert_equal 'README.md', `git diff --name-only --cached`.strip
      end
    end

    it 'raises error while adding unexisting files' do
      in_tmpdir do
        `git init`

        assert_raises(Gitw::GitError) do
          @git.add('README.md')
        end
      end
    end
  end

  describe '.commit' do
    it 'generates commit' do
      in_tmpdir do
        `git init`
        `touch README.md`
        `git add README.md`

        @git.commit(git_options: { c: 'commit.gpgsign=false' },
                    message: 'commit')

        assert_equal 'commit', `git log -1 --pretty=%B`.strip
      end
    end

    it 'raises error on commit failure' do
      in_tmpdir do
        `git init`

        assert_raises(Gitw::GitError) do
          @git.commit(git_options: { c: 'commit.gpgsign=false' },
                      message: 'commit')
        end
      end
    end

    it 'raises error on commit when not in a repository' do
      in_tmpdir do
        assert_raises(Gitw::GitError) do
          @git.commit(git_options: { c: 'commit.gpgsign=false' },
                      message: 'commit')
        end
      end
    end
  end

  describe '.rev_parse' do
    it 'run in repository' do
      in_tmpdir do
        `git init`

        @git.rev_parse
      end
    end

    it 'raises error when not in a repository' do
      in_tmpdir do
        assert_raises(Gitw::GitError) do
          @git.rev_parse
        end
      end
    end

    describe '.git_dir' do
      it 'provides shortcut to rev-parse git-dir' do
        in_tmpdir do
          `git init`

          assert_equal '.git', @git.git_dir
        end
      end
    end

    describe '.toplevel' do
      it 'provides shortcut to rev-parse show-toplevel' do
        in_tmpdir do |tmpdir|
          `git init`

          assert_equal tmpdir, @git.toplevel
        end
      end
    end

    describe '.absolute_git_dir' do
      it 'provides shortcut to rev-parse absolute-git-dir' do
        in_tmpdir do |tmpdir|
          `git init`

          assert_equal File.join(tmpdir, '.git'), @git.absolute_git_dir
        end
      end
    end

    describe '.is_inside_git_dir' do
      it 'returns false from work tree' do
        in_tmpdir do |_tmpdir|
          `git init`

          refute @git.is_inside_git_dir
        end
      end

      it 'returns true from git dir' do
        in_tmpdir do |_tmpdir|
          `git init`

          Dir.chdir('.git') do
            assert @git.is_inside_git_dir
          end
        end
      end
    end

    describe '.is_inside_work_tree' do
      it 'returns true from work tree' do
        in_tmpdir do |_tmpdir|
          `git init`

          assert @git.is_inside_work_tree
        end
      end

      it 'returns false from git dir' do
        in_tmpdir do |_tmpdir|
          `git init`

          Dir.chdir('.git') do
            refute @git.is_inside_work_tree
          end
        end
      end
    end

    describe '.is_bare_repository' do
      it 'returns true from bare repository' do
        in_tmpdir do |_tmpdir|
          `git init --bare`

          assert @git.is_bare_repository
        end
      end

      it 'returns false from standard repository' do
        in_tmpdir do |_tmpdir|
          `git init`

          refute @git.is_bare_repository
        end
      end
    end

    describe '.is_shallow_repository' do
      it 'returns false from standard repository' do
        in_tmpdir do |_tmpdir|
          `git init`

          refute @git.is_shallow_repository
        end
      end
    end
  end

  describe '.status' do
    it 'returns status output' do
      in_tmpdir do
        `git init`

        assert_match(/No commits yet/, @git.status)
        assert_match(/nothing to commit/, @git.status)
      end
    end

    it 'raises error when not in a repository' do
      in_tmpdir do
        assert_raises(Gitw::GitError) do
          @git.status
        end
      end
    end
  end

  describe '.status_obj' do
    it 'returns status as an obj' do
      in_tmpdir do
        `git init`

        status = @git.status_obj

        assert status
      end
    end

    it 'allows to check if file is untracked' do
      in_tmpdir do
        `git init`
        `touch README.md`

        status = @git.status_obj

        assert status.untracked?('README.md')
      end
    end

    it 'allows to check if file has changed' do
      in_tmpdir do
        `git init`
        `touch README.md`
        `git add README.md`
        `echo a > README.md`

        status = @git.status_obj

        assert status.changed?('README.md')
      end
    end
  end

  describe '.fetch' do
    it 'can fetch in repository without remote' do
      in_tmpdir do
        `git init`

        output = @git.fetch

        assert_equal '', output
      end
    end

    it 'can fetch references in repository with remote' do
      in_tmpdir do
        `git init a`
        `git clone a b 2>/dev/null`

        Dir.chdir('b') do
          output = @git.fetch

          assert_equal '', output
        end
      end
    end

    it 'raises error when not in a repository' do
      in_tmpdir do
        assert_raises(Gitw::GitError) do
          @git.fetch
        end
      end
    end
  end

  describe '.pull' do
    it 'cannot pull in repository without remote' do
      in_tmpdir do
        `git init`

        assert_raises(Gitw::GitError) do
          @git.pull
        end
      end
    end

    it 'raises error when not in a repository' do
      in_tmpdir do
        assert_raises(Gitw::GitError) do
          @git.pull
        end
      end
    end
  end

  describe '.push' do
    it 'cannot push in repository without remote' do
      in_tmpdir do
        `git init`

        assert_raises(Gitw::GitError) do
          @git.push
        end
      end
    end

    it 'raises error when not in a repository' do
      in_tmpdir do
        assert_raises(Gitw::GitError) do
          @git.push
        end
      end
    end
  end

  describe '.remote' do
    it 'has remote list empty by default' do
      in_tmpdir do
        `git init`

        assert_equal '', @git.remote(verbose: true)
      end
    end

    it 'raises error when not in a repository' do
      in_tmpdir do
        assert_raises(Gitw::GitError) do
          @git.remote
        end
      end
    end
  end

  describe '.remotes' do
    it 'has remote list empty by default' do
      in_tmpdir do
        `git init`

        assert_equal '', @git.remote(verbose: true)
      end
    end

    it 'allows to find remote by name' do
      in_tmpdir do
        `git init`
        `git remote add origin test`

        remote = @git.remotes.by_name('origin')

        assert_equal 'origin', remote.name
        assert_equal 'test', remote.url
      end
    end
  end
end
