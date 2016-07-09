require "euler6_counterexample_search/version"

module Euler6CounterexampleSearch
  class Processor1
  def initialize
    @modulo117649_6th_roots_generators = ModuloK6thRoots.new(117649)
    @candidates = []
  end
  def input_data
    (1...117649).each.lazy.select do |x|
       x % 2 != 0 &&
       x % 3 != 0 &&
       x % 7 != 0
    end.map {|x| x ** 6}
  end

  def process

    input_data.each do |f6|
      rem = f6 % 117649
      @modulo117649_6th_roots_generators[rem].each do |e|
        e6=e**6
        break if e6 >= f6
        @candidates << (f6 -e6)
      end

    end

  end

  def report
    puts
    puts @candidates.size
    divby3, nondivby3 = *(@candidates.group_by{|x| x % 9}.to_a.sort)
    p @candidates.group_by{|x| x % 3}.map{|k,v| [k, v.size]}.sort
    p divby3[1].group_by{|x| x % 729 ==0}.map{|k,v| [k, v.size]}

  end
  end

end
