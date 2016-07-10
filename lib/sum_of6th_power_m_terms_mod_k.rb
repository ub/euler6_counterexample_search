require 'set'

class SumOf6thPowerMTermsModK
  MAX_TERMS = 4

  def initialize(k)
    @k=k
    @v = Array.new(MAX_TERMS + 1) { [] } # 1 to MAX_TERMS, 0 unused
    caculate_residues
    calculate_reachable_sums
  end

  def [](m)
    @v[m].dup
  end

  private
  def caculate_residues
    rs = Set.new
    @k.times do |x|
      r = x**6 % @k
      rs << r
    end
    @v[1] = rs.to_a.sort
  end

  def calculate_reachable_sums
    rs = self[1]
    prev_sums = rs
    rs_sums = Set.new
    (2..MAX_TERMS).each do |m|
      prev_sums.each do |sum_1|
        rs.each do |r|
          rs_sums << (sum_1 + r) % @k
        end
      end
      @v[m] = prev_sums = rs_sums.to_a.sort
    end
  end
end