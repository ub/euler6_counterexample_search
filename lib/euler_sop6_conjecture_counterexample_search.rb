require 'hypothesis'
require 'modulo_k_6th_root_generator'
module EulerSop6ConjectureCounterexampleSearch
  class StartHypothesesGenerator

    def generate
      (1...117649).each.lazy.select do |x|
        x % 2 != 0 &&
            x % 3 != 0 &&
            x % 7 != 0
      end.each do | x |
        Hypothesis.create!(value: x**6, terms_count: 5, factor:1)
      end
    end
  end

  # process hypotheses with 5 terms count: generate for each a number of equivalent hypotheses with 4 terms count
  class Process5
    def initialize
      @modulo_p6pow_6th_roots_generators = ModuloK6thRoots.new(117649)
    end

    def process
      #TODO + scope childless
      Hypothesis.for_terms(5).unrefuted.each do |f6|
        rem = f6 % 117649
        subgoals_count = 0
        @modulo_p6pow_6th_roots_generators[rem].each do |e|
          e6=e**6
          break if  f6 <= e6
          subgoal = f6 - e6
          subgoal.div_by!(117649)
          subgoal.save!
          subgoals_count += 1
        end
        if subgoals_count == 0
          Refutation.create!(hypothesis: f6, reason: :no_subgoals_generated)
        end
      end
    end
  end
end