# Magical primes
#2,   3,   5,   7,   13,   19,   43,   61,   97,   157,   277
class SumOfTwo6thPowerTermsModuloP_Discriminator
  def initialize(p)
    @p = p

    @rs = (1...p).map { |x| x ** 6 % p }.to_a.sort.uniq
=begin
    composeable = []
    @rs[1...p].repeated_combination(2) do |a,b|
      aplusb = (a+b) % p
      composeable << aplusb if @rs.include?(aplusb)
    end
    uncomposeable = @rs - composeable
    if composeable.empty?
      puts "ALL"
    else
      puts "SOME"
    end
=end
  end

  def print
    puts "DISCRIMINATOR #@p"
  end
  def quickly_testable?(x)

    res = x % @p
    # if x modulo p is 6th power residue then for x = a**6 + b**6
    # a  % p == 0
    @rs[0...@p].include?( res)
  end
end

if __FILE__ == $0

  [5,      13,   19,   43,   61,   97,   157,   277].each do |p|
    SumOfTwo6thPowerTermsModuloP_Discriminator.new(p)
  end


end