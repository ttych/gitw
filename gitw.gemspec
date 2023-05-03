# frozen_string_literal: true

require_relative 'lib/gitw/version'

Gem::Specification.new do |spec|
  spec.name = 'gitw'
  spec.version = Gitw::VERSION
  spec.authors = ['Thomas Tych']
  spec.email = ['thomas.tych@gmail.com']

  spec.summary = 'git command wrabper'
  spec.description = spec.summary
  spec.homepage = 'https://gitlab.com/ttych/gitw'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  # The `git ls-files -z` loads the files in the RubyGem
  # that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git
                                                             .circleci appveyor])
    end
  end
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{\A#{spec.bindir}/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bump', '~> 0.10.0'
  spec.add_development_dependency 'byebug', '~> 11.1', '>= 11.1.3'
  spec.add_development_dependency 'minitest', '~> 5.18'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'reek', '~> 6.1', '>= 6.1.4'
  spec.add_development_dependency 'rubocop', '~> 1.21'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.29.0'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  spec.add_development_dependency 'simplecov', '~> 0.22.0'
  spec.add_development_dependency 'yard-doctest', '~> 0.1.17'
  spec.add_development_dependency 'yardstick', '~>  0.9.9'
end
