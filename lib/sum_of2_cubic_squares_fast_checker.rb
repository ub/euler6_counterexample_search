require 'prime'
class SumOf2CubicSquaresFastChecker
  def initialize( max_prime = 913247)
    @max_prime = max_prime
  end

  def could_be?(test_value)
    return false if test_value % 4 == 3

    Prime.each do |p|
      return true if @max_prime && p > @max_prime # might be false positive
      p2 = p * p
      return true if p2 > test_value
      next unless p & 3 == 3
      x = test_value
      while x % p == 0
        p6 ||= p2 ** 3
        q, rem = x.divmod(p6)
        return false if rem != 0
        x = q
      end

    end

  end
end