# frozen_string_literal: true

module Gitw
  # git options
  # allow to define available options
  #   and to create standard args for execution
  class GitOpts
    attr_reader :opts

    def initialize
      @allowed = []
      @allowed_index = {}

      @opts = []
    end

    def allow(label, **kwargs)
      allowed_opt = GitAllowedOpt.new(label, **kwargs)
      return unless allowed_opt

      @allowed << allowed_opt
      allowed_opt.each_label do |allowed_opt_label|
        @allowed_index[allowed_opt_label] = allowed_opt
      end

      self
    end

    def add(label, arg = nil)
      linked_allowed_opt = @allowed_index[label]
      if linked_allowed_opt
        opt = linked_allowed_opt.build_opt(label, arg)
        @opts << opt unless opt.nil?
      end

      self
    end

    def from_a(options)
      options.each do |option|
        add(option)
      end

      self
    end

    def from_h(options)
      options.each do |k, v|
        add(k, v)
      end

      self
    end

    def from(options)
      case options.class
      when Hash then from_h(options)
      when Array then from_a(options)
      else
        self
      end
    end
  end

  # git allowed options
  # to defined single allowed options
  # to be included in git options
  class GitAllowedOpt
    attr_reader :label, :short, :long, :with_arg, :multiple

    def initialize(label, short: nil, long: nil, with_arg: false, multiple: false)
      @label = label.to_s.to_sym
      @short = short
      @long = long
      @with_arg = with_arg
      @multiple = multiple
    end

    def each_label(&block)
      [label, label.to_s, short, long].compact.each(&block)
    end

    def build_opt(_label, arg)
      return if with_arg && arg.nil?

      opt = []
      opt << (long || short)
      opt << arg if with_arg
      opt.compact
    end
  end
end
