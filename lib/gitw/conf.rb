# frozen_string_literal: true

module Gitw
  # to configure settings for gitw
  # allow to specify :
  # - path for git binary
  class Conf
    attr_accessor :git_path

    def initialize(env: ENV)
      @env = env

      @git_path = @env['GIT_PATH'] || 'git'
    end
  end
end
