require 'hypothesis'
require 'modulo_k_6th_root_generator'
require 'n_terms_aggregated_residues_constraints_calc'

require 'filtering_rules'
require 'goal_replacement'
module EulerSop6ConjectureCounterexampleSearch
  class StartHypothesesGenerator

    def generate
      (1...117649).each.lazy.select do |x|
        x % 2 != 0 &&
            x % 3 != 0 &&
            x % 7 != 0
      end.each do |x|
        Hypothesis.create!(value: x**6, terms_count: 5, factor: 1)
      end
    end
  end

  # process hypotheses with 5 terms count: generate for each a number of equivalent hypotheses with 4 terms count
  class Process5
    def initialize
      @modulo_p6pow_6th_roots_generators = ModuloK6thRoots.new(117649)
      @refutations=[]
      @subgoals = []
    end

    def process(pseudo_6th_powers)
      pseudo_6th_powers.each do |f6|
        rem = f6 % 117649
        subgoals_count = 0
        @modulo_p6pow_6th_roots_generators[rem].each do |e|
          e6=e**6
          break if f6 <= e6
          subgoal = f6 - e6
          subgoal.div_by!(117649)
          @subgoals << subgoal
          subgoals_count += 1
        end
        if subgoals_count == 0
          @refutations << Refutation.new(hypothesis: f6, reason: :no_subgoals_generated)
        end
      end
    end

    #TODO DRY (common superclass/module)
    def save_process_results
      Refutation.import @refutations
      Hypothesis.import @subgoals
      @subgoals.size
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

      @refutations=[]
      @modifications = []
      @input_size = nil

    end

    def filter(candidates)
      @input_size = candidates.count

      # find_each(batch_size: 5).lazy. see https://github.com/rails/rails/issues/21874#issuecomment-145947380
      candidates.select do |h|
        @constraint_2_6.check(h, @refutations, @modifications) && @aggregated_residue_mod_8_constraint.check(h, @refutations)
      end.select do |h|
        @constraint_3_6.check(h, @refutations, @modifications) && @aggregated_residue_mod_9_constraint.check(h, @refutations)
      end.select do |h|
        @constraint_7_6.check(h, @refutations, @modifications) && @aggregated_residue_mod_7_constraint.check(h, @refutations)
      end.select do |h|
        @constraint_31_6.check(h, @refutations, @modifications) && @aggregated_residue_mod_31_constraint.check(h, @refutations)
      end
    end

    def save_filter_results
      Refutation.import @refutations
      @modifications.each do |h|
        h.save!
      end
      @input_size - @refutations.size
    end
  end

  class Process4
    include GoalReplacement

    def initialize
      @modulo7_res1_tactic = Modulo_m_Res1_Tactic.new(7)
      @modulo9_res1_tactic = Modulo_m_Res1_Tactic.new(9)
      @modulo8_res1_tactic = Modulo_m_Res1_Tactic.new(8)
      @default_tactic = BruteForceTactic.new
      @refutations=[]
      @subgoals = []
      if_none do |parent_hypothesis|
        @refutations << Refutation.new(hypothesis: parent_hypothesis, reason: :no_subgoals_generated)
      end
    end

    def if_none(&block)
      @modulo7_res1_tactic.if_none_block = block
      @modulo9_res1_tactic.if_none_block = block
      @modulo8_res1_tactic.if_none_block = block
      @default_tactic.if_none_block = block
      self
    end

    def process(hypotheses)
      hypotheses.each do |h|
        if @modulo7_res1_tactic.match? h
          @modulo7_res1_tactic.apply(h) { |subgoal| @subgoals<< subgoal }
        elsif @modulo9_res1_tactic.match? h
          @modulo9_res1_tactic.apply(h) { |subgoal| @subgoals<< subgoal }
        elsif @modulo8_res1_tactic.match? h
          @modulo8_res1_tactic.apply(h) { |subgoal| @subgoals<< subgoal }
        else
          @default_tactic.apply(h) { |subgoal| @subgoals<< subgoal }
        end

      end

    end

    def save_process_results
      Refutation.import @refutations
      Hypothesis.import @subgoals
      @subgoals.size
    end

  end

  class Filter3
    include FilteringRules

    def initialize
      @constraint_2_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(2)
      @constraint_3_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(3)
      @constraint_7_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(7)
      @constraint_31_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(31)
      @constraint_67_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(67)
      @constraint_79_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(79)
      @constraint_139_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(139)
      @constraint_223_6 = DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(223)

      @aggregated_residue_mod_7_constraint = RemainderIsRepresentableAsSumOf6powResidues.new(7)
      @aggregated_residue_mod_8_constraint = RemainderIsRepresentableAsSumOf6powResidues.new(8)
      @aggregated_residue_mod_9_constraint = RemainderIsRepresentableAsSumOf6powResidues.new(9)
      @aggregated_residue_mod_19_constraint = RemainderIsRepresentableAsSumOf6powResidues.new(19)
      @aggregated_residue_mod_31_constraint = RemainderIsRepresentableAsSumOf6powResidues.new(31)

      @refutations=[]
      @modifications = []
      @input_size = nil
    end

    def filter(candidates)
      @input_size = candidates.count
      candidates.each do |h|
        @aggregated_residue_mod_9_constraint.check(h, @refutations) and
            @aggregated_residue_mod_19_constraint.check(h, @refutations) and
            @aggregated_residue_mod_31_constraint.check(h, @refutations) and
            @aggregated_residue_mod_7_constraint.check(h, @refutations) and
            @aggregated_residue_mod_8_constraint.check(h, @refutations) and

            @constraint_2_6.check(h, @refutations, @modifications) and
            @constraint_3_6.check(h, @refutations, @modifications) and
            @constraint_31_6.check(h, @refutations, @modifications) and
            @constraint_67_6.check(h, @refutations, @modifications) and
            @constraint_79_6.check(h, @refutations, @modifications) and
            @constraint_139_6.check(h, @refutations, @modifications) and
            @constraint_223_6.check(h, @refutations, @modifications) and
            @constraint_7_6.check(h, @refutations, @modifications) and
            #TODO optimize encore - only for modifications added for 7/8/9 constraints
            @aggregated_residue_mod_8_constraint.check(h, @refutations) and # encore
            @aggregated_residue_mod_9_constraint.check(h, @refutations) and # encore
            @aggregated_residue_mod_7_constraint.check(h, @refutations)


      end
    end

    def save_filter_results
      Refutation.import @refutations
      @modifications.each do |h|
        h.save!
      end
      @input_size - @refutations.size
    end

  end


  class Process3
    include GoalReplacement

    def initialize
      @modulo7_res1_tactic = Modulo_m_Res1_Tactic.new(7)
      @modulo8_res1_tactic = Modulo64_with_lookahead_Tactic.new
      @modulo9_res1_tactic = Modulo729_with_lookahead_Tactic.new
      @modulo19_tactic = Modulo_19_Tactic.new
      @default_tactic = BruteForceTactic.new
      @refutations=[]
      @subgoals = []
      if_none do |parent_hypothesis|
        @refutations << Refutation.new(hypothesis: parent_hypothesis, reason: :no_subgoals_generated)
      end
    end

    def if_none(&block)
      @modulo7_res1_tactic.if_none_block = block
      @modulo8_res1_tactic.if_none_block = block
      @modulo9_res1_tactic.if_none_block = block
      @modulo19_tactic.if_none_block = block
      @default_tactic.if_none_block = block
      self
    end

    def process(hypotheses)
      hypotheses.each do |h|
        if @modulo7_res1_tactic.match? h
          @modulo7_res1_tactic.apply(h) { |subgoal| @subgoals<< subgoal }
        elsif @modulo9_res1_tactic.match? h
          @modulo9_res1_tactic.apply(h) { |subgoal| @subgoals<< subgoal }
        elsif @modulo19_tactic.match? h
          @modulo19_tactic.apply(h) { |subgoal| @subgoals<< subgoal }
        elsif @modulo8_res1_tactic.match? h
          @modulo8_res1_tactic.apply(h) { |subgoal| @subgoals<< subgoal }
        else
          @default_tactic.apply(h) { |subgoal| @subgoals<< subgoal }
        end
      end
    end

    def save_process_results
      Refutation.import @refutations
      Hypothesis.import @subgoals
      @subgoals.size
    end

  end


  class Process3_ZR_Opt
    include GoalReplacement

    def initialize
      @tactic43 = ZeroRequisiteTactic.new 43, 3
      @tactic19 = ZeroRequisiteTactic.new 19, 3
      @tactic13 = ZeroRequisiteTactic.new 13, 3
      @tactic7 = ZeroRequisiteTactic.new 7, 3

      @refutations=[]
      @subgoals = []
      if_none do |parent_hypothesis|
        @refutations << Refutation.new(hypothesis: parent_hypothesis, reason: :no_subgoals_generated)
      end

    end

    def if_none(&block)
      @tactic43.if_none_block = block
      @tactic19.if_none_block = block
      @tactic13.if_none_block = block
      @tactic7.if_none_block = block
      self
    end

    def process(hypotheses)
      hypotheses.each do |h|
       if @tactic43.match? h
         @tactic43.apply(h) { |subgoal| @subgoals<< subgoal }
       elsif @tactic19.match? h
         @tactic19.apply(h) { |subgoal| @subgoals<< subgoal }
       elsif @tactic13.match? h
         @tactic13.apply(h) { |subgoal| @subgoals<< subgoal }
       elsif @tactic7.match? h
         @tactic7.apply(h) { |subgoal| @subgoals<< subgoal }
       else
         ; #TODO nop for now
       end
      end
    end

    def save_process_results
      Refutation.import @refutations
      Hypothesis.import @subgoals
      @subgoals.size
    end


  end

  class Process3_NZR_Opt
    include GoalReplacement

    def initialize
      @tactic43 = NonZeroRequisiteTactic.new 43, 3
      @tactic37 = NonZeroRequisiteTactic.new 37, 3
      @tactic31 = NonZeroRequisiteTactic.new 31, 3
      @tactic19 = NonZeroRequisiteTactic.new 19, 3
      @tactic13 = NonZeroRequisiteTactic.new 13, 3

      @refutations=[]
      @subgoals = []
      if_none do |parent_hypothesis|
        @refutations << Refutation.new(hypothesis: parent_hypothesis, reason: :no_subgoals_generated)
      end

    end

    def if_none(&block)
      @tactic43.if_none_block = block
      @tactic37.if_none_block = block
      @tactic31.if_none_block = block
      @tactic19.if_none_block = block
      @tactic13.if_none_block = block
      self
    end

    def process(hypotheses)
      hypotheses.each do |h|
       if @tactic43.match? h
         @tactic43.apply(h) { |subgoal| @subgoals<< subgoal }
       elsif @tactic37.match? h
         @tactic37.apply(h) { |subgoal| @subgoals<< subgoal }
       elsif @tactic31.match? h
         @tactic31.apply(h) { |subgoal| @subgoals<< subgoal }
       elsif @tactic19.match? h
         @tactic19.apply(h) { |subgoal| @subgoals<< subgoal }
       elsif @tactic13.match? h
         @tactic13.apply(h) { |subgoal| @subgoals<< subgoal }
       else
         # never should get here -- 13 covers all!
         @default_tactic.apply(h) { |subgoal| @subgoals<< subgoal }
       end
      end
    end

    def save_process_results
      Refutation.import @refutations
      Hypothesis.import @subgoals
      @subgoals.size
    end


  end


  class Filter2
    include FilteringRules

    def initialize

      @prime_divisibility_constraints = [2, 3, 7, 11, 19, 23, 31, 43, 47, 59, 67, 71, 79, 83, 103, 107, 127, 131, 139,
                                         151, 163, 167, 179, 191, 199, 211, 223, 227, 239, 251, 263, 271].map do |p|
        DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(p)
      end

      @aggregated_residues_constraints =
          [7, 8, 9, 13, 19, 31, 37, 43, 61, 67, 73, 79, 109, 139, 223].map do |k|
            RemainderIsRepresentableAsSumOf6powResidues.new k
          end

      @refutations=[]
      @modifications = []
      @input_size = nil
    end

    def filter(candidates)
      @input_size = candidates.count
      candidates.each do |h|
        @prime_divisibility_constraints.all? do |constraint|
          constraint.check(h, @refutations, @modifications)
        end &&
            @aggregated_residues_constraints.all? do |ar_constraint|
              ar_constraint.check(h, @refutations)
            end
      end

      def save_filter_results
        Refutation.import @refutations
        @modifications.each do |h|
          h.save!
        end
        @input_size - @refutations.size
      end

    end

  end

  class Process2
    include GoalReplacement

    def initialize
      @smart_tactics =
          [19, 7, 9, 5, 8, 43, 13, 277, 61, 97, 157].map do |m|
            TwoTermsAllButOneTermDivisibleBy_p_Tactic.new m
          end
      @default_tactic = BruteForceTactic.new
      @refutations=[]
      @subgoals = []
      if_none do |parent_hypothesis|
        @refutations << Refutation.new(hypothesis: parent_hypothesis, reason: :no_subgoals_generated)
      end

    end

    def process(hypotheses)
      hypotheses.each do |h|
        processed = @smart_tactics.any? do |tactic|
          matched = tactic.match?(h)
          if matched
            tactic.apply(h) { |subgoal| @subgoals<< subgoal }
          end
          matched
        end
        unless processed
          @default_tactic.apply(h) { |subgoal| @subgoals<< subgoal }
        end
      end
    end

    def if_none(&block)
      @smart_tactics.each { |t| t.if_none_block = block }
      @default_tactic.if_none_block = block

    end

    def save_process_results
      Refutation.import @refutations
      Hypothesis.import @subgoals
      @subgoals.size
    end

  end


  class Process1
    def initialize
      @refutations=[]
      @confirmations = []

    end

    def process(hypotheses)
      hypotheses.each do |h|
        if is_sixth_power? h
          @confirmations << Confirmation.new(hypothesis: h, root: sxthrt(h))
        else
          @refutations << Refutation.new(hypothesis: h, reason: :term_is_not_a_6th_power)
        end
      end
    end

    def save_process_results
      Refutation.import @refutations
      Confirmation.import @confirmations
      @confirmations.size
    end


    private
    def is_sixth_power?(h)
      sixth_root=sxthrt(h)
      sixth_root.round ** 6 == h.x
    end

    def sxthrt(h)
      Math.cbrt(Math.sqrt(h.x)).round
    end
  end

end