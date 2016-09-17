require 'hypothesis'
require 'modulo_k_6th_root_generator'

require 'filtering_rules'


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

    def process(pseudo_6th_powers)
      pseudo_6th_powers.each do |f6|
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

  class Filter4
    include FilteringRules
    def initialize
      @constraint_2_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(2)
      @constraint_3_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(3)
      @constraint_7_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(7)
      @constraint_31_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(31)

      @aggregated_residue_mod_7_constraint = RemainderIsRepresentableAsSumOf6powResidues.new(7)
      @aggregated_residue_mod_8_constraint = RemainderIsRepresentableAsSumOf6powResidues.new(8)
      @aggregated_residue_mod_9_constraint = RemainderIsRepresentableAsSumOf6powResidues.new(9)
      @aggregated_residue_mod_31_constraint = RemainderIsRepresentableAsSumOf6powResidues.new(31)
    end

    def filter(candidates)

      # find_each(batch_size: 5).lazy. see https://github.com/rails/rails/issues/21874#issuecomment-145947380
      candidates.select do |h|
        @constraint_2_6.check(h) && @aggregated_residue_mod_8_constraint.check(h)
      end.select do |h|
        @constraint_3_6.check(h) && @aggregated_residue_mod_9_constraint.check(h)
      end.select do |h|
        @constraint_7_6.check(h) && @aggregated_residue_mod_7_constraint.check(h)
      end.select do |h|
        @constraint_31_6.check(h) && @aggregated_residue_mod_31_constraint.check(h)
      end

    end

  end

  class Process4
    def initialize
    end
    def process(hypotheses)

    end

  end
end