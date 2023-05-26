# frozen_string_literal: true

require 'uri'

module Gitw
  module Git
    # git repository url
    class URL
      SSH_RE = %r{
           ^
           (?:(?<user>[^@/]+)@)?
           (?<host>[^:/]+)
           :(?!/)
           (?<path>.*?)
           $
    }x.freeze

      attr_reader :raw_url, :url, :user, :host, :path

      def initialize(raw_url)
        @raw_url = raw_url
        @url = nil
        @user = nil
        @host = nil
        @path = nil

        parse
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def parse
        if (match = SSH_RE.match(raw_url))
          @user = match[:user]
          @host = match[:host]
          @path = match[:path]
          @url = raw_url.clone
        elsif (uri = URI.parse(raw_url))
          @user = uri.user
          @host = uri.host
          @path = uri.path
          @url = uri.to_s
        end
        @path = @path.chomp('.git').sub(%r{^/+}, '').sub(%r{/+$}, '')
      end

      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
      def path_dirname
        File.dirname(path)
      end

      def path_basename
        File.basename(path)
      end

      def to_s
        url.to_s
      end
    end
  end
end
