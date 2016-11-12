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

  def zero_req_residues
    rqs = requisites
    rqs.select {|k,v| v.include? 0}.keys.sort
  end

  def req_residues
    rqs = requisites
    rqs.select {|k,v| ! v.empty?}.keys.sort
  end



  def size
    @combinations.size
  end
end

if __FILE__ == $0

  require 'prime'
  sample = (4..400).to_a
  sample.each do |p|
    next if Prime::instance.prime? p
    calc = N_TermsAggregatedResiduesConstraintsCalc.new(p,3)

    e = calc.exclusions
    r = calc.requisites

    rc = r.values.count {|x| ! x.empty?}
    ec = e.values.count {|x| ! x.empty?}
    if rc > 0 || ec > 0
      puts "p: #{p} => exclusions: #{ec}/#{calc.size}; requisites: #{rc}/#{calc.size}"
    end

  end

end