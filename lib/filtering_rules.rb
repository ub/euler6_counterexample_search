require 'sums_of6th_power_m_terms_mod_k'
require 'refutation'

module FilteringRules
  class DivisibilityBy_p_ImpliesDivisibilityBy_p_6
    def initialize(p)
      @p = case p
             when 2
               8
             when 3
               9
             else
               p
           end
      @p_6 = p**6
    end

    def check(hypothesis,refutations, modifications)
      while hypothesis.x % @p == 0
        q6, r6 = hypothesis.x.divmod(@p_6)
        if r6 == 0
          hypothesis.x = q6
          hypothesis.factor = hypothesis.factor * @p_6
        else
          refutations << Refutation.new(hypothesis: hypothesis, reason: :divisible_by_p_but_not_by_p_6,
          parameter: @p)
          modifications << hypothesis if hypothesis.changed?
          return false
        end
      end
      modifications << hypothesis if hypothesis.changed?
      return hypothesis
    end
  end

  class RemainderIsRepresentableAsSumOf6powResidues
    def initialize(k)
      @k = k
      #TODO: make simplified check object-oriented
      case k
        when 7,8,9 #simplified check
          # no-op
        else
          @checker = SumsOf6thPowerMTermsModK.memoized(@k)
      end
    end

    def check(hypothesis, refutations)
      case @k
        when 7,8,9
          if hypothesis.x % @k > hypothesis.terms_count
            refutations << Refutation.new(hypothesis: hypothesis, reason:
                :remainder_not_representable_as_sum_of_6th_power_residues,
                parameter: @k)
            return false
          end
        else
          unless @checker === hypothesis
            refutations << Refutation.new(hypothesis: hypothesis, reason:
                :remainder_not_representable_as_sum_of_6th_power_residues,
                               parameter: @k)
            return false
          end
      end
      return hypothesis
    end

  end
end