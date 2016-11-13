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

  def is_root?(x, radicand)
    @rows[radicand].base_include?( x % @k)
  end

  private


  class PeriodicSequence
    def initialize(period, base_sequence)
      @period, @base_sequence =
      period, base_sequence

    end

    def base_include?( r)
      @base_sequence.include? r
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
    mod_p6_roots = calculate_mod_p6_roots(mod_p_roots, i)

    ModuloK6thRoots::PeriodicSequence.new(@k, mod_p6_roots.sort)

  end

  private

  def calculate_mod_p6_roots(mod_p_roots, residue)
    mod_p_roots.map do |a|
      df =( 6 * a** 5) % @p
      inv_df = @multiplicative_inverse_mod_p[df]
      m = 1
      b = a
      5.times do
        m = m * @p
        _f_div_m = ((-b**6 + residue) / m) % @p
        t = (inv_df * _f_div_m) % @p
        b = b + m * t
      end
      b
    end
  end


end


class ModuloK6thRootsWithLookahead
  def initialize(k, l)
    @m = l
    @k = k
    @lines = Array.new(@m){[]}
    @m.times do |n|
      index = n**6 % @m
      next if index == 0
      @lines[index] << n
    end
  end

  def [](hyp)
    v_mod_m = hyp.value % @m

    base_sequence = []
    hyp.terms_count.times do |i|
      index =  v_mod_m - i*@k
      base_sequence += @lines[index]
    end
    ModuloK6thRoots::PeriodicSequence.new(@m, base_sequence.sort)
  end

end

class Modulo64_Roots_512_lookahead < ModuloK6thRootsWithLookahead
  def initialize
    super(64,512)
  end
end


class Modulo729_Roots_6561_lookahead < ModuloK6thRootsWithLookahead
  def initialize
    super( 729,6561)
  end
end