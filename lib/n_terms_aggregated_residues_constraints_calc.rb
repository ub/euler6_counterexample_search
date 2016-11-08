class N_TermsAggregatedResiduesConstraintsCalc
  def initialize(p, n)
    @p = p
    @rs = (0...p).map { |x| x ** 6 % p }.to_a.sort.uniq
    @combinations = Hash.new {|h,k| h[k]=[]}
        @rs.repeated_combination(n).map do |a|
          ar = a.inject(&:+) % @p
          @combinations[ar] << a
        end.sort.uniq
  end

  def exclusions
    e = {}
    @combinations.each_pair do | ar, v |
      e[ar]=@rs - v.flatten.uniq
    end
    Hash[ e.sort_by { |key, val| key } ]
  end

  def requisites
    e = {}
     @combinations.each_pair do | ar, v |
      e[ar]=v.reduce(&:&)
    end
     Hash[ e.sort_by { |key, val| key } ]
  end
end