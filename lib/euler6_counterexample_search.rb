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
        @candidates << (f6 -e6) /117649
      end

    end

  end

  def report
    puts
    puts @candidates.size
    divby3, nondivby3 = *(@candidates.group_by{|x| x % 9}.to_a.sort)
    p @candidates.group_by{|x| x % 3}.map{|k,v| [k, v.size]}.sort
    group_by_mod7 = @candidates.group_by { |x| x % 7 }.map { |k, v| [k, v.size] }.sort
    p group_by_mod7
    p divby3[1].group_by{|x| x % 729 ==0}.map{|k,v| [k, v.size]}
    test_3⁶ = SumsOf6thPowerMTermsModK.new(729)
    filtered3⁶ = divby3[1].select do |x|
      test_3⁶ === [x, 4]
    end.count
    puts divby3[1].size
    puts filtered3⁶
    puts "-----"
    filter_report(@candidates,729,4)
    filter_report(@candidates,7,4)
    filter_report(@candidates,8,4)
    filter_report(@candidates,9,4)

    filter_report(@candidates,31,4)
    filter_report(@candidates,64,4)
    filter_report(@candidates,72,4)

    puts "--------\n\n"

    odd_or_divisible_by_2⁶                = Proc.new {|x| x % 2 == 1 || x % 64 == 0}
    not_divisible_by_3_or_divisible_by_3⁶ = Proc.new {|x| x % 3 != 0 || x % 729 == 0}
    not_divisible_by_7_or_divisible_by_7⁶ = Proc.new {|x| x % 7 != 0 || x % 117649 == 0}


    filtered = @candidates.select(&odd_or_divisible_by_2⁶).select(&not_divisible_by_3_or_divisible_by_3⁶).
               select(&not_divisible_by_7_or_divisible_by_7⁶)
    puts "ANY REMAINING?"
    (7..100).each do |k|
      filter_report_interesting(filtered,k,4)

    end


  end

  def filter_report(numbers, k, m)
    filter = SumsOf6thPowerMTermsModK.new(k)
    total = numbers.size
    filtered = "%8d" %(numbers.count {|x| filter === [x,m]})
    l = "%6d" % k
    puts "#{l}: #{filtered}/#{total}"
  end
  def filter_report_interesting(numbers, k, m)
    filter = SumsOf6thPowerMTermsModK.new(k)
    total = numbers.size
    filtered = numbers.count { |x| filter === [x, m] }
    filtered_string = "%8d" %(filtered)
    l = "%6d" % k
    puts "#{l}: #{filtered_string}/#{total}" if filtered != total
  end

  end



end
