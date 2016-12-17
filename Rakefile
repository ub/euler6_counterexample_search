require "rspec/core/rake_task"
require 'active_record_migrations'
require 'rubocop/rake_task'
ActiveRecordMigrations.load_tasks

RSpec::Core::RakeTask.new(:spec)


RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names', '-l']
end

task :default => :spec
