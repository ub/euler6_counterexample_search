require "rspec/core/rake_task"
require 'active_record_migrations'
ActiveRecordMigrations.load_tasks

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
