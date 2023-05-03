# frozen_string_literal: true

require 'test_helper'

class TestGitOption < Minitest::Test
  def test_option_can_be_defined_with_long_option
    Gitw::GitOption.new('option')
  end

  def test_option_can_be_defined_with_short_option
    Gitw::GitOption.new('option', short: 'short')
  end

  def test_option_can_be_defined_with_argument_flag
    Gitw::GitOption.new('option', short: 'short', has_argument: true)
  end

  def test_option_can_format
    opt = Gitw::GitOption.new('option')

    assert_equal ['--option'], opt.format
  end

  def test_option_can_format_with_argument
    opt = Gitw::GitOption.new('option', has_argument: true)

    assert_equal ['--option', 'arg'], opt.format('arg')
  end

  def test_option_can_format_skipping_argument
    opt = Gitw::GitOption.new('option', has_argument: false)

    assert_equal ['--option'], opt.format('arg')
  end
end
