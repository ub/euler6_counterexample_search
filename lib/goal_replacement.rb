# replace goal with subgoals
module GoalReplacement
  class AbstractTactic
    def initialize
      @if_none_block = Proc.new { |ignore|}
    end
    attr_accessor :if_none_block

    def if_none(&block)
      @if_none_block = block
      self
    end

    def match?(v)
      raise NotImplementedError "Abstract method '#{__method__}' should be redefined in subclasses"
    end

  end


  class AllButOneTermDivisibleBy_p_Tactic < AbstractTactic
    def initialize(p, mod_p6pow_6th_roots_gen)
      @p6pow = p ** 6
      @mod_p6pow_6th_roots = mod_p6pow_6th_roots_gen
      super()
    end

    def apply(v)
      res = v % @p6pow
      once = false
      @mod_p6pow_6th_roots[res].each do |u|
        u6 = u **6
        break if v < u6
        once = true
        subgoal_hypothesis = (v - u6).div_by! @p6pow
        yield subgoal_hypothesis
      end
      @if_none_block.call(v) unless once
    end
  end

  class Modulo_m_Res1_Tactic < AllButOneTermDivisibleBy_p_Tactic
    def initialize(m)
      @m = m
      p = case m
             when 8
               2
             when 9
               3
             else
               m
          end
      super(p, ModuloK6thRoots.new(p**6))
    end

    def match?(v)
      v % @m == 1
    end
  end

  class Modulo_p6_with_lookahead_Tactic < AbstractTactic
    def initialize(m, p6, gen)
      @m = m
      @p6pow = p6
      @roots_with_lookahead_gen = gen
    end

    def match?(v)
      v % @m == 1
    end

    def apply(v)

      once = false
      @roots_with_lookahead_gen[v].each do |u|
        u6 = u **6
        break if v < u6
        once = true
        subgoal_hypothesis = (v - u6).div_by! @p6pow
        yield subgoal_hypothesis
      end
      @if_none_block.call(v) unless once
    end
  end

  class Modulo64_with_lookahead_Tactic < Modulo_p6_with_lookahead_Tactic
    def initialize
      super(8,64, Modulo64_Roots_512_lookahead.new)
    end
  end

  class Modulo729_with_lookahead_Tactic < Modulo_p6_with_lookahead_Tactic
    def initialize
      super(9,729, Modulo729_Roots_6561_lookahead.new)
    end
  end



  class Modulo_19_Tactic  < AllButOneTermDivisibleBy_p_Tactic
    def initialize

      @p = 19
      super(@p, ModuloP6K6thRootsSE.new(@p))
    end

    def match?(v)
      v.terms_count.between?(2,3) && [1,7,11].include?(v % @p)
    end


    end

  class BruteForceTactic < AbstractTactic
    def apply(v)
      r7 = v % 7
      r8 = v % 8
      r9 = v % 9
      not7 = r7==v.terms_count
      oddonly = r8==v.terms_count
      not3 = r9==v.terms_count
      u = -1
      once = false
      loop do
        if oddonly
          u += 2
        else
          u += 1
        end
        #TODO
        #next if u == 0
        next if not3 && u % 3 == 0
        next if not7 && u % 7 == 0
        u6 = u**6
        break if v < u6
        once = true
        yield (v - u6)
      end
      @if_none_block.call(v) unless once
    end

    def match?(_)
      true
    end

  end

end