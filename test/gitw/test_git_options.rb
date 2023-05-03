# frozen_string_literal: true

require 'test_helper'

class TestGitOptions < Minitest::Test
  def test_can_be_instantiate_with_empty_option
    Gitw::GitOptions.new
  end

  def test_can_be_instantiate_with_options
    git_options = Gitw::GitOptions.new(
      Gitw::GitOption.new('option1'),
      Gitw::GitOption.new('option2')
    )

    assert git_options.option_for('option1')
    assert git_options.option_for('option2')
    refute git_options.option_for('option3')
  end

  def test_can_add_option
    git_options = Gitw::GitOptions.new(
      Gitw::GitOption.new('option1'),
      Gitw::GitOption.new('option2')
    )

    git_options
      .add(Gitw::GitOption.new('option3'))

    assert git_options.option_for('option3')
  end

  def test_can_chain_option_adding
    git_options = Gitw::GitOptions.new
    git_options
      .add(Gitw::GitOption.new('option1'))
      .add(Gitw::GitOption.new('option2'))
      .add(Gitw::GitOption.new('option3'))

    assert git_options.option_for('option1')
    assert git_options.option_for('option2')
    assert git_options.option_for('option3')
    refute git_options.option_for('option0')
  end

  def test_can_inline_empty_options
    git_options = Gitw::GitOptions.new

    assert_empty git_options.inline
  end

  def test_can_inline_options
    git_options = Gitw::GitOptions.new(
      Gitw::GitOption.new('option1'),
      Gitw::GitOption.new('option2', has_argument: true),
      Gitw::GitOption.new('option3', short: '3')
    )

    assert_equal(
      [['--option1'], ['--option2', 'arg2'], ['--option3']],
      git_options.inline(
        option1: true,
        option2: 'arg2',
        '3': true
      )
    )
  end

  def test_inline_skip_unexpected_options
    git_options = Gitw::GitOptions.new(
      Gitw::GitOption.new('option1')
    )

    assert_equal(
      [['--option1']],
      git_options.inline(
        option1: true,
        option2: 'arg2',
        '3': true
      )
    )
  end
end
