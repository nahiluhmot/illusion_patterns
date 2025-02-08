require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:spec)

desc "Run the linter and tests"
task default: [:spec, :standard]
