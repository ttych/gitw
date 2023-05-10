# frozen_string_literal: true

require 'uri'

module Gitw
  class Repository
    # Repository URL encapsulation
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

      def parse
        parse_as_ssh || parse_as_uri
        @path = @path.chomp('.git').sub(%r{^/+}, '').sub(%r{/+$}, '')
      end

      def parse_as_ssh
        return unless (match = SSH_RE.match(raw_url))

        @user = match[:user]
        @host = match[:host]
        @path = match[:path]
        @url = raw_url.clone
        true
      end

      def parse_as_uri
        return unless (uri = URI.parse(raw_url))

        @user = uri.user
        @host = uri.host
        @path = uri.path
        @url = uri.to_s
        true
      end

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
