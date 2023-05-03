# frozen_string_literal: true

module Gitw
  # to define git options
  # to group unitary git option
  class GitOptions
    def initialize(*options)
      @options = {}
      options.each { |option| add option }
    end

    def add(option)
      if option
        @options ||= {}
        @options[option.option.to_sym] = option
        @options[option.short.to_sym] = option unless option.short.nil?
      end

      self
    end

    def option_for(option_label)
      @options[option_label.to_sym]
    end

    def inline(**args)
      args.each.with_object([]) do |(k, v), inlined|
        option = option_for(k.to_sym)
        next unless option

        inlined << option.format(v)
      end.compact
    end
  end
end
