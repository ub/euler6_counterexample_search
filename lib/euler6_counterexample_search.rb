require "euler6_counterexample_search/version"

require 's6p_hypothesis'

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
  def output
    @filtered
  end
  def process

    input_data.each do |f6|
      rem = f6 % 117649
      @modulo117649_6th_roots_generators[rem].each do |e|
        e6=e**6
        break if e6 >= f6
        @candidates << S6pHypothesis.new((f6 - e6) /117649, 4, 117649)
      end

    end
    @filtered=@candidates.select{|x|x.reduce_and_check(8,64)} .select{|x|x.reduce_and_check(9,729)}.
      select{|x|x.reduce_and_check(7,117649)}.select{|x|x.reduce_and_check(31,887_503_681)}

  end

  def report
    puts
    puts @candidates.size
    puts @filtered.size
    print "FILT %9:"; p @filtered.group_by{|x| x % 9}.map{|k,v| [k, v.size]}.sort
    print "FILT %8:"; p @filtered.group_by{|x| x % 8}.map{|k,v| [k, v.size]}.sort
    group_by_mod7 = @filtered.group_by { |x| x % 7 }.map { |k, v| [k, v.size] }.sort
    p group_by_mod7
    print "FILT 31:"; p @filtered.group_by { |x| x % 31 }.map { |k, v| [k, v.size] }.sort
    # p divby3[1].group_by{|x| x % 729 ==0}.map{|k,v| [k, v.size]}
=begin
    test_3⁶ = SumsOf6thPowerMTermsModK.new(729)
    filtered3⁶ = divby3[1].select do |x|
      test_3⁶ === x
    end.count
    puts divby3[1].size
    puts filtered3⁶
    puts "-----"
    filter_report(@candidates,729)
    filter_report(@candidates,7)
    filter_report(@candidates,8)
    filter_report(@candidates,9)

    filter_report(@candidates,31)
    filter_report(@candidates,64)
    filter_report(@candidates,72)


    puts "--------\n\n"

    odd_or_divisible_by_2⁶                 = Proc.new {|x| x % 2 == 1 || x % 64 == 0}
    not_divisible_by_3_or_divisible_by_3⁶  = Proc.new {|x| x % 3 != 0 || x % 729 == 0}
    not_divisible_by_7_or_divisible_by_7⁶  = Proc.new {|x| x % 7 != 0 || x % 117649 == 0}
    not_divisible_by_31_or_divisible_by_31⁶ = Proc.new {|x| x % 31 != 0 || x % 887_503_681 == 0}


    f7 =SumsOf6thPowerMTermsModK.new(7)
    filtered = @candidates.select(&odd_or_divisible_by_2⁶).select(&not_divisible_by_3_or_divisible_by_3⁶).
               select(&not_divisible_by_7_or_divisible_by_7⁶).select(&not_divisible_by_31_or_divisible_by_31⁶).
               select{|x| f7 === x }
    puts "ANY REMAINING?"
    # (7..1024).each do |k|
    #   filter_report_interesting(filtered,k,4)
    #
    # end


    # 512 961, 1024

    # 512:    12741/13047
    # 961:    10817/13047
    # 1024:    12693/13047
    # filter_report(filtered,2048,4)
    # filter_report(filtered,4096,4)
    # filter_report(filtered,29791,4)
    # 2048:    12660/13047
    # 4096:    12652/13047
    # 29791:    10755/13047

    # (1024..5000).each do |k|
    #   filter_report_interesting(filtered,k,4)
    #
    # end

    # 1922:    10817/13047  (961 x 2)


    # 1024:    12693/13047
    # 1536:    12741/13047
    # 1922:    10817/13047
    # 2048:    12660/13047
    # 2560:    12741/13047
    # 2883:    10817/13047
    # 3072:    12693/13047
    # 3584:    12741/13047
    # 3844:    10817/13047
    # 4096:    12652/13047
    # 4608:    12741/13047
    # 4805:    10817/13047



    # filter_report_2(filtered,31**3,4)
    # FILTERED BY 29791
    # =>2292

    puts filtered.size

    p filtered.group_by {|x| x % 31}.to_a.map{|k,v| [k,v.size]}.sort
    p filtered.group_by {|x| x % 3}.to_a.map{|k,v| [k,v.size]}.sort

    reduced = filtered.lazy.map {|x| x  % 729 == 0 ? x / 729 : x}.
        map {|x| x  % 64 == 0 ? x / 64 : x}.
        map {|x| x  % 117649 == 0 ? x / 117649 : x}.
        map {|x| x  % 887_503_681 == 0 ? x / 887_503_681 : x}.to_a

    rnf = reduced.select(&odd_or_divisible_by_2⁶).select(&not_divisible_by_3_or_divisible_by_3⁶).
        select(&not_divisible_by_7_or_divisible_by_7⁶).select(&not_divisible_by_31_or_divisible_by_31⁶)
    puts "REDUCED & FILTERED:#{rnf.size}"


    print "31:"; p rnf.group_by {|x| x % 31}.to_a.map{|k,v| [k,v.size]}.sort
    print " 7:"; p rnf.group_by {|x| x % 7}.to_a.map{|k,v| [k,v.size]}.sort
    print " 3:"; p rnf.group_by {|x| x % 3}.to_a.map{|k,v| [k,v.size]}.sort
    print " 9:"; p rnf.group_by {|x| x % 9}.to_a.map{|k,v| [k,v.size]}.sort
    print " 8:"; p rnf.group_by {|x| x % 8}.to_a.map{|k,v| [k,v.size]}.sort

    # REDUCED & FILTERED:10347
    # 31:[[1, 672], [2, 675], [3, 630], [4, 486], [6, 427], [7, 251], [8, 681], [12, 440], [14, 624], [15, 334], [16, 310], [17, 618], [19, 440], [23, 667], [24, 259], [25, 445], [27, 460], [28, 625], [29, 657], [30, 646]]
    # 7:[[1, 2581], [2, 2597], [3, 2582], [4, 2587]]
    # 3:[[1, 10278], [2, 69]]
    # 9:[[1, 10241], [2, 23], [4, 18], [5, 27], [7, 19], [8, 19]]
    # 8:[[0, 10], [1, 10081], [3, 82], [5, 90], [7, 84]]
    #

    puts "DIV BY 3"

    reduced_divby3=filtered.select{|x| x % 3 == 0}.map {|x| x  / 729}.select(&not_divisible_by_3_or_divisible_by_3⁶).
        map {|x| x  % 64 == 0 ? x / 64 : x}.select(&odd_or_divisible_by_2⁶)
    puts reduced_divby3.size

    print "31:"; p reduced_divby3.group_by {|x| x % 31}.to_a.map{|k,v| [k,v.size]}.sort
    print " 7:"; p reduced_divby3.group_by {|x| x % 7}.to_a.map{|k,v| [k,v.size]}.sort
    print " 3:"; p reduced_divby3.group_by {|x| x % 3}.to_a.map{|k,v| [k,v.size]}.sort
    print " 9:"; p reduced_divby3.group_by {|x| x % 9}.to_a.map{|k,v| [k,v.size]}.sort
    print " 8:"; p reduced_divby3.group_by {|x| x % 8}.to_a.map{|k,v| [k,v.size]}.sort

    # DIV BY 3
    # 131
    # 31:[[1, 8], [2, 5], [3, 10], [4, 7], [6, 5], [7, 4], [8, 5], [12, 10], [14, 2], [15, 9], [16, 10], [17, 3], [19, 5], [23, 4], [24, 9], [25, 7], [27, 4], [28, 12], [29, 10], [30, 2]]
    # 7:[[1, 29], [2, 34], [3, 30], [4, 38]]
    # 3:[[1, 62], [2, 69]]
    # 9:[[1, 25], [2, 23], [4, 18], [5, 27], [7, 19], [8, 19]]
    # 8:[[1, 129], [5, 1], [7, 1]]
    #
=end

  end

  def filter_report(numbers, k)
    filter = SumsOf6thPowerMTermsModK.new(k)
    total = numbers.size
    filtered = "%8d" %(numbers.count {|x| filter === x})
    l = "%6d" % k
    puts "#{l}: #{filtered}/#{total}"
  end
  def filter_report_interesting(numbers, k)
    filter = SumsOf6thPowerMTermsModK.new(k)
    total = numbers.size
    filtered = numbers.count { |x| filter === x }
    filtered_string = "%8d" %(filtered)
    l = "%6d" % k
    puts "#{l}: #{filtered_string}/#{total}" if filtered != total
  end

  def filter_report_2(numbers, k)
    filter = SumsOf6thPowerMTermsModK.new(k)
    total = numbers.size
    filtered = numbers.reject { |x| filter === x }
    filtered_string = "%8d" %(filtered)
    l = "%6d" % k
    unless filtered.empty?
      puts "FILTERED BY #{k}"
      puts filtered.size
      rems = filtered.map {|x| x % k}.sort.uniq
      p rems
    end
  end

  def filter_report_3(numbers, k)
    filter = SumsOf6thPowerMTermsModK.new(k)
    total = numbers.size
    filtered = numbers.reject { |x| filter === x }
    filtered_string = "%8d" %(filtered.size)
    l = "%6d" % k
    unless filtered.empty?
      puts "FILTERED BY #{k}"
      puts filtered.size
      rems = filtered.map {|x| x % k}.sort.uniq
      puts "K:#{k}"
      p rems
    end
  end


  end

  class Processor2
    def initialize(input)
      @input = input
      @modulo729_6th_roots_generators = ModuloK6thRoots.new(729)
    end
    def input_data
      @input
    end

    def process

      groups_by_combability =    input_data.group_by{|x| x % 9 == 1}
      combable3, noncombable = groups_by_combability[true], groups_by_combability[false]
      process_combable3 combable3
    end

    def process_combable3( data)
      @candidates = []
      data.each do |q|
        rem = q % 729
        @modulo729_6th_roots_generators[rem].each do |d|
          d6=d**6
          break if q <= d6
          hypothesis = (q - d6).reduce_and_check(9,729)
          @candidates << hypothesis if hypothesis
        end
      end
      puts "PROC2:", @candidates.size

      @filtered=@candidates.select{|x|x.reduce_and_check(8,64)}
      puts "FILT2:", @filtered.size
      @filtered = @filtered.select{|x|x.reduce_and_check(7,117649)}
      puts "FILT7:", @filtered.size

      print "FILT 31:"; p @filtered.group_by { |x| x % 31 }.map { |k, v| [k, v.size] }.sort

      @filtered =  @filtered.select{|x|x.reduce_and_check(31,887_503_681)}
      puts "FILT31:", @filtered.size

    end
  end

end
