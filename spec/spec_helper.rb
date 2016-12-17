$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'active_record'
require 'sqlite3'
require 'yaml'
require 'database_cleaner'
require 'factory_girl'

configuration = YAML::load(IO.read('db/config.yml'))
ActiveRecord::Base.establish_connection(configuration['test'])

require 'hypothesis'

require 'modulo_k_6th_root_generator'
require 'sums_of6th_power_m_terms_mod_k'

RSpec.configure do |c|
  c.filter_run focus: true
  c.run_all_when_everything_filtered = true

  c.before(:suite) do
    FactoryGirl.find_definitions
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  c.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
