
class SumsOf6thPowerMTermsModK
  MAX_TERMS = 4

  def initialize(k)
    @k=k
    @v = Array.new(MAX_TERMS + 1) { [] } # 1 to MAX_TERMS, 0 unused
    caculate_residues
    calculate_reachable_sums
  end

  def self.memoized(k)
    @@cache ||= Hash.new
    @@cache[k] ||= self.new(k)
  end


  def [](m)
    @v[m].dup
  end

  def ~()
    self.dup.invert
  end

  def ===(hyp)
    v,m = hyp.x, hyp.terms_count
    return self[m].include?(v % @k)
  end

  protected

  def invert
    @v = @v.dup
    (1..MAX_TERMS).each do |i|
      reachable = @v[i]
      unreachable = (0...@k).to_a - reachable
      @v[i] = unreachable
    end
    self
  end



  private
  def caculate_residues
    rs = []
    @k.times do |x|
      r = x**6 % @k
      rs << r
    end
    @v[1] = rs.sort.uniq
  end

  def calculate_reachable_sums
    rs = self[1]
    prev_sums = rs
    rs_sums = []
    (2..MAX_TERMS).each do |m|
      prev_sums.each do |sum_1|
        rs.each do |r|
          rs_sums << (sum_1 + r) % @k
        end
      end
      @v[m] = prev_sums = rs_sums.uniq.sort
    end
  end
end