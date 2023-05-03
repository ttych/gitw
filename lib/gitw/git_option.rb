# frozen_string_literal: true

module Gitw
  # define git option
  # to be grouped in options
  class GitOption
    attr_reader :option, :short

    def initialize(option, short: nil, has_argument: false)
      @option = option
      @short = short
      @has_argument = has_argument
    end

    def format(argument = nil)
      ["--#{@option}", (@has_argument && argument.to_s) || nil].compact
    end
  end
end
