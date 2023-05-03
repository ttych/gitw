# frozen_string_literal: true

module Test
  module Helpers
    # tmp utilities for test
    module Tmp
      def in_temp_dir
        tmpdir = Dir.mktmpdir
        tmpdir_realpath = File.realpath(tmpdir)
        Dir.chdir(tmpdir_realpath) do
          yield tmpdir_realpath if block_given?
        end
      ensure
        FileUtils.rm_rf(tmpdir_realpath) if tmpdir_realpath
      end
    end
  end
end
