require 'sums_of6th_power_m_terms_mod_k'
class S6pHypothesis
  attr_accessor :x, :factor, :terms_count
  def initialize(value,n, fact = 1)
    @x,@factor,@terms_count = value, fact, n
  end

  def %(d)
    @x % d
  end

  def /(d)
    S6pHypothesis.new(@x / d,@terms_count, @factor * d)
  end

  def -(s)
    S6pHypothesis.new(@x - s, @terms_count - 1, @factor)
  end

  def <= (other)
    @x <= other
  end

  def < (other)
    @x < other
  end

  def reduce_and_check(divisor, divisor6thp)
    while (r = @x % divisor) == 0
      q6, r6 = @x.divmod(divisor6thp)
      return nil if r6 != 0
      @x = q6
      @factor *= divisor6thp
    end
    case divisor
      when 7,8,9
        return nil if r > @terms_count
      else
        checker = SumsOf6thPowerMTermsModK.memoized(divisor)
        return nil unless checker === self
    end
    self
  end



end