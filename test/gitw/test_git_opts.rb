# frozen_string_literal: true

require 'test_helper'

require 'gitw/git_opts'

# unit test for GitOpts
class TestGitOpts < Minitest::Test
  def test_can_allow_opt
    Gitw::GitOpts.new
                 .allow(:option, short: '-o', long: '--option')
  end

  def test_can_allow_multiple_opt
    Gitw::GitOpts.new
                 .allow(:option_a, short: '-a', long: '--option-a')
                 .allow(:option_b, short: '-b', long: '--option-b')
                 .allow(:option_c, short: '-c', long: '--option-c')
  end

  def test_allowed_opt_acts_as_a_filter_to_adding_opt
    git_opts = Gitw::GitOpts.new
                            .allow(:option_a, short: '-a', long: '--option-a')
                            .allow(:option_b, short: '-b', long: '--option-b')
                            .allow(:option_c, short: '-c', long: '--option-c')
    git_opts.add(:option_a)
            .add(:option_b)
            .add(:option_d)

    opts = *git_opts

    assert_equal ['--option-a', '--option-b'], opts
  end

  def test_can_have_multiple_time_same_option
    git_opts = Gitw::GitOpts.new
                            .allow(:a, short: '-a')
                            .allow(:b, short: '-b', with_arg: true)
                            .allow(:c, short: '-c')
    git_opts.add(:a)
            .add(:a)
            .add(:b, '123')
            .add(:b, '456')

    opts = *git_opts

    assert_equal ['-a', '-a', '-b', '123', '-b', '456'], opts
  end
end

# unit test for GitAllowedOpt
class TestGitAllowedOpt < Minitest::Test
  def test_each_label_with_short_only
    allowed_opt = Gitw::GitAllowedOpt.new(:label_short, short: '-l')

    assert_equal [:label_short, 'label_short', '-l'], allowed_opt.each_label.to_a
  end

  def test_each_label_with_long_only
    allowed_opt = Gitw::GitAllowedOpt.new(:label_long, long: '--long')

    assert_equal [:label_long, 'label_long', '--long'], allowed_opt.each_label.to_a
  end

  def test_each_label_with_short_and_long
    allowed_opt = Gitw::GitAllowedOpt.new(:label, short: '-l', long: '--label')

    assert_equal [:label, 'label', '-l', '--label'], allowed_opt.each_label.to_a
  end

  def test_build_opt_without_arg
    allowed_opt = Gitw::GitAllowedOpt.new(:label, short: '-l')

    assert_equal ['-l'], allowed_opt.build_opt('not expected')
  end

  def test_build_opt_with_arg
    allowed_opt = Gitw::GitAllowedOpt.new(:label, short: '-l', with_arg: true)

    assert_equal ['-l', 'expected'], allowed_opt.build_opt('expected')
  end

  def test_build_opt_when_missing_arg
    allowed_opt = Gitw::GitAllowedOpt.new(:label, short: '-l', with_arg: true)

    assert_nil allowed_opt.build_opt(nil)
  end
end
