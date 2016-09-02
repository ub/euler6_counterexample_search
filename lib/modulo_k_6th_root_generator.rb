class ModuloK6thRoots
  def initialize(k)
    @k = k
    lines = Array.new(k){[]}
    @k.times do |n|
      index = n**6 % @k
      next if index == 0
      lines[index] << n
    end
    @rows = lines.map {|base| PeriodicSequence.new(k, base)}
  end

  def [](i)
    @rows[i]
  end

  private


  class PeriodicSequence
    def initialize(period, base_sequence)
      @period, @base_sequence =
      period, base_sequence

    end

    def each
      if block_given?
        return if @base_sequence.empty?
        c = 0
        loop do
          @base_sequence.each do |x|
            yield x + c
          end
          c+=@period
        end
      else
        self.to_enum(:each)
      end
    end
  end

end

# space efficient version
class ModuloP6K6thRootsSE
  def initialize(p)
    @p = p
    @k = p ** 6
    @multiplicative_inverse_mod_p = Array.new(p)
    @sixth_roots_mod_p = Array.new(p){[]}
    (1...@p).each {|i| @multiplicative_inverse_mod_p[i] = i **(@p-2) % @p}
    (1...@p).each {|x| x6 = x**6 % @p; @sixth_roots_mod_p[x6] << x}
  end

  def [](i)
   #  x ** 6 - i ≡ 0 (mod p)
    mod_p_roots = @sixth_roots_mod_p[i % @p]
    mod_p2_roots = lift( mod_p_roots, @p, i)
    mod_p3_roots = lift( mod_p2_roots, @p*@p, i)
    mod_p4_roots = lift( mod_p3_roots, @p**3, i)
    mod_p5_roots = lift( mod_p4_roots, @p**4, i)
    mod_p6_roots = lift( mod_p5_roots, @p**5, i)

    ModuloK6thRoots::PeriodicSequence.new(@k, mod_p6_roots.sort)

  end

  private
  def lift(roots, m, r6)
    #  x ** 6 - i ≡ 0 (mod p)
    roots.map do |a|
      lift_one(a, m, r6)
    end.flatten
  end

  def lift_one(a, m, r6)
    df =( 6 * a** 5) % @p
    # puts "DF=#{df}"
    _f_div_m =  (- (a ** 6 - r6) / m) % @p
    inv_df = @multiplicative_inverse_mod_p[df]
    t = (inv_df * _f_div_m) % @p
    a + m * t
  end
end