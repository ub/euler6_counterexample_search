class RandomPseudo6PowerGenerator
  def initialize(top=117649)
    @top = top
    @pool = (1..@top).to_a
    @m7, @ndb7 = @pool.partition { |x| x % 7 == 0 }
  end


  def generate
    if rand(5) == 0

      @m7 = @m7.select(&:even?)
      @ndb7 = @ndb7.select(&:odd?)
    else
      @ndb7=@ndb7.select(&:even?)
      odd_to_be_chosen = true
    end

    if rand(5) == 0
      @ndb7 = @ndb7.reject { |x| x % 3 == 0 }
      @m7 = @m7.select { |x| x % 3 == 0 }
    else
      @ndb7 = @ndb7.select { |x| x % 3 == 0 }
      not_divisible_by_3_to_be_chosen = true
    end

    choose4_from(@m7, odd_to_be_chosen, not_divisible_by_3_to_be_chosen) + @ndb7.sample(1)

  end

  def choose4_from(pool, odd=false, ndb3=false)
    if odd
      one, three = pool.partition(&:odd?)
    elsif ndb3
      one, three = pool.partition { |x| x % 3 !=0 }
    else
      return pool.sample(4)
    end

    if odd && ndb3
      if rand(4) == 0
        one = one.reject { |x| x % 3 == 0 }
        three = three.select { |x| x % 3 == 0 }
      else
        one = one.select { |x| x % 3 == 0 }
        one_more, two = three.partition { |x| x % 3 !=0 }
        return [one.sample, one_more.sample, two.sample(2)].flatten
      end
    end
    return [one.sample, three.sample(3)].flatten

  end
end

