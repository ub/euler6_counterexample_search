class N_TermsAggregatedResiduesConstraintsCalc
  def initialize(p, n)
    @p = p
    @rs = (0...p).map { |x| x**6 % p }.to_a.sort.uniq
    @combinations = Hash.new { |h, k| h[k] = [] }
        @rs.repeated_combination(n).map do |a|
          ar = a.inject(&:+) % @p
          @combinations[ar] << a
        end.sort.uniq
  end

  def exclusions
    e = {}
    @combinations.each_pair do | ar, v |
      e[ar] = @rs - v.flatten.uniq
    end
    Hash[ e.sort_by { |key, val| key } ]
  end

  def requisites
    e = {}
     @combinations.each_pair do | ar, v |
      e[ar] = v.reduce(&:&)
     end
     Hash[ e.sort_by { |key, val| key } ]
  end

  def zero_req_residues
    rqs = requisites
    rqs.select { |k, v| v.include? 0 }.keys.sort
  end

  def req_residues
    rqs = requisites
    rqs.select { |k, v| ! v.empty? }.keys.sort
  end

  def nz_req_residues
    rqs = requisites
    rqs.select { |k, v| !v.empty? && !v.include?(0) }.keys.sort
  end

  def size
    @combinations.size
  end
end

if __FILE__ == $0

  require 'prime'
  sample = Prime.instance.each.take(100).to_a
  sample.each do |p|
    calc = N_TermsAggregatedResiduesConstraintsCalc.new(p, 2)

    nzrc = calc.nz_req_residues.size
    # rc = r.values.count {|x| ! x.empty?}
    # ec = e.values.count {|x| ! x.empty?}
    if  nzrc > 1
      puts "p: #{p} => non-zero-reqs: #{nzrc}/#{calc.size}"
    end
  end

end
