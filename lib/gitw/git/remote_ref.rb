# frozen_string_literal: true

module Gitw
  module Git
    # encapsulate git remote references
    class RemoteRefs
      def initialize(refs)
        @refs = refs.compact

        @index_name = {}
        @index_url = {}

        @refs.each do |ref|
          @index_name[ref.name] = ref
          @index_url[ref.url] ||= []
          @index_url[ref.url] << ref
        end
      end

      def by_name(name)
        @index_name[name]
      end

      def by_url(url)
        @index_url[url]
      end

      def self.parse(output)
        return new unless output

        refs = output.each_line.with_object({}) do |entry, refs_store|
          remote = RemoteRef.parse(entry)
          next unless remote

          refs_store[remote.name] ||= remote
          refs_store[remote.name].update(remote)
        end
        new(refs.values)
      end
    end

    # encapsulate git remote reference entry
    class RemoteRef
      REMOTE_LINE_RE = /^(?<name>\w+)
                         \s+
                         (?<url>[^\s]+)
                         \s+
                         \((?<mode>fetch|push)\)$/x.freeze

      attr_reader :name, :fetch, :push

      def initialize(name, fetch: nil, push: nil)
        @name = name
        @fetch = fetch
        @push = push
      end

      def url
        fetch || push
      end

      def update(other_ref)
        return self if self == other_ref
        return self if name != other_ref.name

        @fetch = other_ref.fetch || @fetch
        @push = other_ref.push || @push
        self
      end

      def self.parse(ref_line)
        return unless (match = REMOTE_LINE_RE.match(ref_line.strip))

        new(match[:name],
            match[:mode].to_sym => match[:url])
      end
    end
  end
end
