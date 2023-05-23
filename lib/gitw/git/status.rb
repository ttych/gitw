# frozen_string_literal: true

module Gitw
  module Git
    # encapsulate git porcelain status output
    class Status
      def initialize(files)
        @files = files.compact

        @index_map = {}
        @workingtree_map = {}
        @untracked_map = {}
        @files.each do |file|
          @index_map[file.path] = file if file.index_changed?
          @workingtree_map[file.path] = file if file.workingtree_changed?
          @untracked_map[file.path] = file if file.untracked?
        end
      end

      def changed?(filename)
        @index_map[filename] || @workingtree_map[filename]
      end

      def untracked?(filename)
        @untracked_map[filename]
      end

      def self.parse(output)
        return new unless output

        files = output.each_line.with_object([]) do |entry, files_store|
          files_store << StatusFile.parse(entry)
        end
        new(files)
      end
    end

    # encapsulate git status file entry
    class StatusFile
      STATUS_LINE_RE = /^(?<index_status>.)
                         (?<workingtree_status>.)
                         \s
                         (?:(?<orig_path>.*?)\s->\s)?
                         (?<path>.*)$/x.freeze

      STATUS_MAP = {
        ' ' => :unmodified,
        'M' => :modified,
        'T' => :file_type_changed,
        'A' => :added,
        'D' => :deleted,
        'R' => :renamed,
        'C' => :copied,
        'U' => :updated,
        '?' => :untracked,
        '!' => :ignored
      }.freeze

      attr_reader :path

      def initialize(path, index_status: nil, workingtree_status: nil, orig_path: nil)
        @path = path
        @index_status = index_status
        @workingtree_status = workingtree_status
        @orig_path = orig_path
      end

      def index_changed?
        return false if STATUS_MAP[@index_status] == :unmodified
        return false if STATUS_MAP[@index_status] == :ignored
        return false if STATUS_MAP[@index_status] == :untracked

        true
      end

      def workingtree_changed?
        return false if STATUS_MAP[@workingtree_status] == :unmodified
        return false if STATUS_MAP[@workingtree_status] == :ignored
        return false if STATUS_MAP[@workingtree_status] == :untracked

        true
      end

      def untracked?
        return true if STATUS_MAP[@index_status] == :untracked
        return true if STATUS_MAP[@workingtree_status] == :untracked

        false
      end

      def self.parse(status_line)
        return unless (match = STATUS_LINE_RE.match(status_line))

        new(match[:path],
            index_status: match[:index_status],
            workingtree_status: match[:workingtree_status],
            orig_path: match[:orig_path])
      end
    end
  end
end
