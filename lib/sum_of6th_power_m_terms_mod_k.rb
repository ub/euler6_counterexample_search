require 'set'

class SumOf6thPowerMTermsModK
  MAX_TERMS=4
  def initialize(k)
    @k=k
    @v = Array.new(MAX_TERMS +1) {[]} # 1 to MAX_TERMS, 0 unused
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
    rs_sums = Set.new
    rs = self[1]
    rs.repeated_combination(2) do |a|
      sum = a.reduce(:+) % @k
      rs_sums << sum
    end
    @v[2] = rs_sums.to_a.sort

  end
end