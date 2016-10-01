$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "bundler/setup"


require 'active_record'
require 'activerecord-import/base'
require 'activerecord-import/active_record/adapters/sqlite3_adapter'

require 'sqlite3'
require 'yaml'

configuration = YAML::load(IO.read('db/config.yml'))
ActiveRecord::Base.establish_connection(configuration['development'])

require 'hypothesis'
require 'refutation'

require 'euler_sop6_conjecture_counterexample_search'