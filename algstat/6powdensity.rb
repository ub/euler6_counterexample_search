FROM = 9**6
TO = 10**6

# DEBUG = 1
def sxrt(n)
  Math::cbrt(Math::sqrt(n)).to_i
rescue => e
  puts "ERROR"
end

def count_sums(n_terms, from, to)
  count_sums_with_maj(to, n_terms, from , to )
end

def dprint(*args)
  print(*args) if defined? DEBUG
end

def count_sums_with_maj(major, n_terms, from, to)
  up = [sxrt(to),major].min
  tab = 4 * (5-n_terms)
  if n_terms == 1
    down = [sxrt(from),1].max
    dprint ' ' * tab
    if down < up
      dprint down,'..', up
    else
      dprint down
    end

    dprint "\n"
    return up - down + 1
  end
  min_major = [sxrt( Float(from)/n_terms), 1].max
  max_major = up
  if n_terms * min_major ** 6 < from
    min_major += 1
  end
  if max_major**6 > to
    max_major -= 1
  end
  count = 0
  (min_major..max_major).each do | maj |
    m6 = maj**6
    dprint ' ' * tab, maj, '+ ', "\n"
    count += count_sums_with_maj(maj, n_terms - 1, [from - m6, 0].max, to - m6 )
  end
  return count
end


 puts count_sums(5,  64,729)

=begin

(7..1000).lazy.map do |n|
  count_sums(5, n**6, (n+1)**6)
end.each_cons(2) do |x,y|
  puts "#{y}, #{y-x}, #{Math.log(Float(y)/x)}"
end
=end
(1..1000).lazy.each do |n|
  from = n ** 6
  to = (n + 1) ** 6
  puts "#{n}\t#{to - from}\t#{count_sums(5, from, to)}"
  STDOUT.flush
end

