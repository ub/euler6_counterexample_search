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

    def process
      Hypothesis.for_terms(5).unrefuted.unreduced.each do |f6|
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
      @check_2_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(2)
      @check_3_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(3)
      @check_7_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(7)
      @check_31_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(31)

      @check7r = RemainderIsRepresentableAsSumOf6powResidues.new(7)
      @check8r = RemainderIsRepresentableAsSumOf6powResidues.new(8)
      @check9r = RemainderIsRepresentableAsSumOf6powResidues.new(9)
      @check31r = RemainderIsRepresentableAsSumOf6powResidues.new(31)
    end

    def filter(candidates)

      # find_each(batch_size: 5).lazy. see https://github.com/rails/rails/issues/21874#issuecomment-145947380
      #TODO better name than check_X_6.check (?) modifies
      candidates.select do |h|
        @check_2_6.check(h) && @check8r.check(h)
      end.select do |h|
        @check_3_6.check(h) && @check9r.check(h)
      end.select do |h|
        @check_7_6.check(h) && @check7r.check(h)
      end.select do |h|
        @check_31_6.check(h) &&
        # with four terms every number  is representable  by sum of 4 6th power residues mod 31
        # 0 is representable only as 0+0+0+0
            @check31r.check(h)
      end
=begin
      @filtered=@candidates.select { |x| x.reduce_and_check(8, 64) }.select { |x| x.reduce_and_check(9, 729) }.
          select { |x| x.reduce_and_check(7, 117649) }.select { |x| x.reduce_and_check(31, 887_503_681) }

=end

    end

  end
end