$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'modulo_k_6th_root_generator'
require 'euler6_counterexample_search'
require 'sums_of6th_power_m_terms_mod_k'
require 's6p_hypothesis'
require 'sum_of2_cubic_squares_fast_checker'

RSpec.configure do |c|
  c.filter_run focus: true
  c.run_all_when_everything_filtered = true
end