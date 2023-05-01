# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'bump/tasks'

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs.push('lib', 'test')
  t.test_files = FileList['test/**/test_*.rb', 'test/**/*_test.rb',]
  t.verbose = true
  t.warning = true
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.stats_options = ['--list-undoc']
end

task default: %i[test rubocop]
