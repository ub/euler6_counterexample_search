require "euler6_counterexample_search/version"

require 's6p_hypothesis'

require 'sum_of_two6th_power_terms_modulo_p_discriminator'

require 'pstore'

require 'benchmark'

require 'csv'

require 'prime'
require 'prettyprint'


require 'sum_of2_cubic_squares_fast_checker'

module Euler6CounterexampleSearch
  module Strategies
    def modulo7_res1_strategy(v)
      @modulo117649_6th_roots_generators ||= ModuloK6thRoots.new(117649)
      res = v % 117649
      @modulo117649_6th_roots_generators[res].each do |u|
        u6 = u **6
        break if v < u6 # не годится для первого "гребня" f,e (f==e)
        hypothesis = (v - u6).reduce_and_check(7,117649)
        @candidates << hypothesis if hypothesis
      end
    end
    def modulo8_res1_strategy(v)
      @modulo64_6th_roots_generators ||= ModuloK6thRoots.new(64)
      res = v % 64
      @modulo64_6th_roots_generators[res].each do |u|
        u6 = u **6
        break if v < u6 # не годится для первого "гребня" f,e
        hypothesis = (v - u6).reduce_and_check(8,64)
        @candidates << hypothesis if hypothesis
      end
    end
    def modulo9_res1_strategy(v)
      @modulo7649_6th_roots_generators ||= ModuloK6thRoots.new(729)
      res = v % 729
      @modulo7649_6th_roots_generators[res].each do |u|
        u6 = u **6
        break if v < u6 # не годится для первого "гребня" f,e
        hypothesis = (v - u6).reduce_and_check(9,729)
        @candidates << hypothesis if hypothesis
      end
    end

    def modulo_p_6pow_divisibility_strategy(v, p, p6pow, modulo_p6pow_6th_roots_generators )
      res = v % p6pow
      modulo_p6pow_6th_roots_generators[res].each do |u|
        u6 = u **6
        break if v < u6
        hypothesis = (v - u6).reduce_and_check(p,p6pow)
        @candidates << hypothesis if hypothesis
      end
    end

    def brute_force_strategy(v)
      r7 = v % 7
      r8 = v % 8
      r9 = v % 9
      not7    = r7==v.terms_count
      oddonly = r8==v.terms_count
      not3    = r9==v.terms_count
      u = -1
      loop do
        if oddonly
          u += 2
        else
          u += 1
        end
        next if not3 && u % 3 == 0
        next if not7 && u % 7 == 0
        u6 = u**6
        break if v < u6
        @candidates << (v - u6)
      end
    end
  end

  module Report
    def print_residues_stat(data, m)
      print "MODULO #{m} residues:"; p data.group_by { |x| x % m }.map { |k, v| [k, v.size] }.sort

    end

    def filter_report(numbers, k)
      filter = SumsOf6thPowerMTermsModK.new(k)
      total = numbers.size
      filtered = "%8d" %(numbers.count {|x| filter === x})
      l = "%6d" % k
      puts "#{l}: #{filtered}/#{total}"
    end

  end
  class Processor1
  def initialize(store_file_name)
    modulo_p6pow_6th_roots_generators = ModuloK6thRoots.new(117649)
    @candidates = []
    @pstore = PStore.new(store_file_name)
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
      modulo_p6pow_6th_roots_generators[rem].each do |e|
        e6=e**6
        break if e6 >= f6
        @candidates << S6pHypothesis.new((f6 - e6) /117649, 4, 117649)
      end

    end
    @filtered=@candidates.select{|x|x.reduce_and_check(8,64)} .select{|x|x.reduce_and_check(9,729)}.
      select{|x|x.reduce_and_check(7,117649)}.select{|x|x.reduce_and_check(31,887_503_681)}

    @pstore.transaction do
      @pstore[:candidates] = @candidates
      @pstore[:filtered] = @filtered
    end

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
    include Strategies
    include Report


    def initialize(store_file_name)
      @modulo729_6th_roots_generators = ModuloK6thRoots.new(729)
      @modulo64_6th_roots_generators = ModuloK6thRoots.new(64)
      @candidates = []
      @pstore = PStore.new(store_file_name)


      @pstore.transaction do
        @input = @pstore[:filtered]
      end


    end
    def input_data
      @input
    end

    def process

      processable_7, rest = input_data.partition {|x| x % 7 == 1}

      processable_7.each {|x| modulo7_res1_strategy(x)}

      processable_9, rest = rest.partition {|x| x % 9 == 1}
      processable_9.each {|x| modulo9_res1_strategy(x)}
      processable_8, rest = rest.partition {|x| x % 8 == 1}
      processable_8.each {|x| modulo8_res1_strategy(x)}
      rest.each {|x| brute_force_strategy(x)}


      @pstore.transaction do
        @pstore[:candidates3] = @candidates
      end



    end

    def report_3(data)
      print_residues_stat(data,7)
      print_residues_stat(data,8)
      print_residues_stat(data,9)
      print_residues_stat(data,13)
      print_residues_stat(data,17)
      print_residues_stat(data,19)

      f19 = SumsOf6thPowerMTermsModK.new 19
      filtered = data.select{|x| f19 === x}
      puts filtered.size, data.size
    end

    def report
      puts "PROC2:", @candidates.size

      @filtered=@candidates.select{|x|x.reduce_and_check(8,64)}
      puts "FILT2:", @filtered.size
      @filtered=@filtered.select{|x|x.reduce_and_check(9,729)}
      puts "FILT3:", @filtered.size

      @filtered = @filtered.select{|x|x.reduce_and_check(7,117649)}
      puts "FILT7:", @filtered.size

      print "FILT 31:"; p @filtered.group_by { |x| x % 31 }.map { |k, v| [k, v.size] }.sort

      @filtered =  @filtered.select{|x|x.reduce_and_check(31,887_503_681)}
      puts "FILT31:", @filtered.size

      f19 = SumsOf6thPowerMTermsModK.new 19
      @filtered = @filtered.select{|x| f19 === x}
      puts "FILT19:", @filtered.size

      print_residues_stat(@filtered,7)
      print_residues_stat(@filtered,8)
      print_residues_stat(@filtered,9)
      print_residues_stat(@filtered,13)
      print_residues_stat(@filtered,17)

      @pstore.transaction do
        @pstore[:filtered3] = @filtered
      end

    end

  end

  class Processor3
    include Strategies
    include Report
    def initialize(store_file_name)
      @modulo729_6th_roots_generators = ModuloK6thRoots.new(729)
      @modulo64_6th_roots_generators = ModuloK6thRoots.new(64)
      @candidates = []
      @pstore = PStore.new(store_file_name)


      @pstore.transaction do
        @input = @pstore[:filtered3]
      end

    end

    def input_data
      @input
    end


    def process
      puts @input.size
      data = @input

      print_residues_stat(data,7)
      print_residues_stat(data,8)
      print_residues_stat(data,9)
      print_residues_stat(data,13)
      print_residues_stat(data,17)
      print_residues_stat(data,19)

      print "PROCESSING ---"

      processable_7, rest = input_data.partition {|x| x % 7 == 1}

      processable_7.each {|x| modulo7_res1_strategy(x)}
      puts "CAND SIZE: #{@candidates.size}"
      puts "REST SIZE: #{rest.size}"

      processable_9, rest = rest.partition {|x| x % 9 == 1}
      processable_9.each {|x| modulo9_res1_strategy(x)}
      puts "CAND SIZE: #{@candidates.size}"
      puts "REST SIZE: #{rest.size}"
      processable_8, rest = rest.partition {|x| x % 8 == 1}
      processable_8.each {|x| modulo8_res1_strategy(x)}
      puts "CAND SIZE: #{@candidates.size}"
      puts "REST SIZE: #{rest.size}"

      rest.each {|x| brute_force_strategy(x)}
      puts "CAND SIZE: #{@candidates.size}"



      @filtered=@candidates.select{|x|x.reduce_and_check(8,64)} .select{|x|x.reduce_and_check(9,729)}.
          select{|x|x.reduce_and_check(7,117649)}.select{|x|x.reduce_and_check(31,887_503_681)}

      _f5 = ~ SumsOf6thPowerMTermsModK.new(5)
      _f13 = ~ SumsOf6thPowerMTermsModK.new(13)
      _f19 = ~ SumsOf6thPowerMTermsModK.new(19)
      _f37 = ~ SumsOf6thPowerMTermsModK.new(37)
      _f43 = ~ SumsOf6thPowerMTermsModK.new(43)
      _f61 = ~ SumsOf6thPowerMTermsModK.new(61)
      _f67 = ~ SumsOf6thPowerMTermsModK.new(67)
      _f73 = ~ SumsOf6thPowerMTermsModK.new(73)
      _f79 = ~ SumsOf6thPowerMTermsModK.new(79)

      puts "FILTERED: #{@filtered.size}"
      # Противоречие filter_report сообщает другие цифры
      @filtered = @filtered.reject do |x|
        case x
          when _f5,_f13,_f19,_f37,_f43, _f61, _f67, _f73, _f79, _f97
            true
          else
            false
        end

      end

      puts "FILTERED: #{@filtered.size}"

=begin
      @pstore.transaction do
        @pstore[:filtered2] = @filtered
        @pstore[:candidates2] = @candidates

      end
=end
      puts "SAVING..."
      t = Benchmark.measure {
      CSV.open 'filtered2.csv', 'wb' do |csv|
        @filtered.each do |hyp|
          hyp.save(csv)
        end
      end
      }
      puts t



    end

  end

  class Explorer3
    include Report
    def initialize(store_file_name)
      @modulo729_6th_roots_generators = ModuloK6thRoots.new(729)
      @modulo64_6th_roots_generators = ModuloK6thRoots.new(64)
      @candidates = []
      @pstore = PStore.new(store_file_name)
      @input = []

      CSV.foreach('filtered2.csv', converters: :integer) do |row |
         @input << S6pHypothesis.from(*row)
      end
      # @pstore.transaction do
      #   @input = @pstore[:filtered2] # 2 min to load!
      # end

    end

    def explore
=begin
      filter_report(@input,729)
      filter_report(@input,7)
      filter_report(@input,8)
      filter_report(@input,9)
      filter_report(@input,11)
      filter_report(@input,13)
      filter_report(@input,17)
      filter_report(@input,23)
      filter_report(@input,29)

      filter_report(@input,31)
      filter_report(@input,37)
      filter_report(@input,41)
      filter_report(@input,43)
      filter_report(@input,47)

      filter_report(@input,53)
      filter_report(@input,59)

      filter_report(@input,61)
      filter_report(@input,67)
      filter_report(@input,73)
      filter_report(@input,79)

      filter_report(@input,83)
      filter_report(@input,89)
      filter_report(@input,91)
      filter_report(@input,97)
      filter_report(@input,101)
      filter_report(@input,103)
=end

      print_residues_stat(@input, 4)
      # primes 4k+1

      print_residues_stat(@input,3)
      print_residues_stat(@input,7)
      print_residues_stat(@input,11)
      puts "..."
      print_residues_stat(@input,13)
      puts "..."
      print_residues_stat(@input,19)
      print_residues_stat(@input,23)
      print_residues_stat(@input,31)
      print_residues_stat(@input,43)
      print_residues_stat(@input,47)
      print_residues_stat(@input,59)
      print_residues_stat(@input,67)
      print_residues_stat(@input,71)
      print_residues_stat(@input,79)
      print_residues_stat(@input,83)
      print_residues_stat(@input,103)
      print_residues_stat(@input,107)
      print_residues_stat(@input,127)
      print_residues_stat(@input,131)
      print_residues_stat(@input,139)
      print_residues_stat(@input,143)
      print_residues_stat(@input,151)
      print_residues_stat(@input,163)
      print_residues_stat(@input,167)
      print_residues_stat(@input,179)
      print_residues_stat(@input,187)

      (191..3000).step(4) do |p|
        next unless Prime.prime?(p)
        print_residues_stat(@input,p)
      end

      print_residues_stat(@input, 4)

      f13 = SumsOf6thPowerMTermsModK.new(13)
      f37 = SumsOf6thPowerMTermsModK.new(37)
      f43 = SumsOf6thPowerMTermsModK.new(43)




=begin
      filter_report(@input,43)
      # filter_report(@input,47)
      # filter_report(@input,64)
      # filter_report(@input,72)

      filter = SumsOf6thPowerMTermsModK.new(43)
      @input.each  {|x|

       puts x.x  unless filter === x

      }
=end

=begin
Run options: include {:focus=>true}
    13:  2490369/2972415
    37:  2188717/2972415
    43:  1896721/2972415

=end
    end

  end

  class Explorer2
    include Report
    include Strategies
    def initialize(csv_file_name = 'filtered2.csv')
      @input = []

      CSV.foreach(csv_file_name, converters: :integer) do |row |
        @input << S6pHypothesis.from(*row)
      end
    end

    def input_data
      @input
    end

    def explore_1mod7
      modulo_p6pow_6th_roots_generators ||= ModuloK6thRoots.new(117649)
      print_residues_stat(input_data,7)

      tm = Benchmark.measure {
        @candidates = []
        input_data.each do | h |
          next unless h % 7 == 1
          modulo7_res1_strategy(h)
        end
      }

      puts "COMBING: #{tm}"

      puts "candidates7 size: #{ @candidates.size}"

      tm1 = Benchmark.measure {
        @candidates.each do |h|
          ok=@candidates.any?{|h|sixth_root = ⁶√(h); sixth_root == sixth_root.to_i}
          puts( "EUREKA!!! " * 6 ) if ok
        end
      }

      puts "checking: #{tm1}"
=begin
MODULO 7 residues:[[1, 273214], [2, 330525]]
COMBING:   1.020000   0.000000   1.020000 (  1.022982)
candidates7 size: 4063
checking:  13.580000   0.000000  13.580000 ( 13.601904)
=end


    end

    def explore
=begin
      sample = input_data[0...50]
      tm = Benchmark.measure {

        sample.each do |h|

          Prime.prime_division(h.x)
        end


      }

      puts tm #=> 285.530000   0.000000 285.530000 (285.929285)
=end
      sample = input_data[0...10]
      print_residues_stat(input_data,7)
      print_residues_stat(input_data,8)
      print_residues_stat(input_data,9)
      print_residues_stat(input_data,11)
      print_residues_stat(input_data,5)
      print_residues_stat(input_data,31)
      print_residues_stat(input_data,13)
      print_residues_stat(input_data,23)
      print_residues_stat(input_data,19)

      modulo_p6pow_6th_roots_generators ||= ModuloK6thRoots.new(117649)
      tm = Benchmark.measure {

        sample.each do |h|
          good = nil
          tm1 = Benchmark.measure {
          good, count = possible_sum_of_2_cubic_squares?(h.x)
          puts "#{good} @ #{count}"
          }
          puts tm1

          if good
            puts "FACTORIZING"
            factors=[]
            tm2 = Benchmark.measure {
              factors= Prime.prime_division(h.x)
            }
            p factors
            puts tm2

            if h % 7 == 1
              puts "COMBING 7"
              tm3 = Benchmark.measure {
              @candidates = []
              modulo7_res1_strategy(h)
              ok=@candidates.any?{|h|sixth_root = ⁶√(h); sixth_root == sixth_root.to_i}
              puts "candidates.size = #{@candidates.size }"
              puts( "EUREKA!!! " * 6 ) if ok
              }
              puts tm3


            end

          end
        end


      }

      puts tm

    end

    def ⁶√(h)
      Math.cbrt(Math.sqrt(h.x))
    end
    def possible_sum_of_2_cubic_squares?(x)
      test_value = x

      Prime.each.with_index do |p, index|

        p2 = p * p
        return true,index if p2 > test_value
        next unless p & 3 == 3

        while test_value % p == 0
          p6 = p2**3
          q, rem = test_value.divmod(p6)
          return false,index if rem != 0
          test_value = q
        end

      end


    end

  end


  class Explorer2a
    include Report
    include Strategies
    def initialize(csv_file_name = 'filtered2.csv')
      @input = []

      CSV.foreach(csv_file_name, converters: :integer) do |row |
        @input << S6pHypothesis.from(*row)
      end
    end

    def input_data
      @input
    end

    def explore

      discriminators = [5, 13,   19,   43,   61,   97,   157,   277].map do |p|
        SumOfTwo6thPowerTermsModuloP_Discriminator.new(p)
      end

      discriminators.each do |d|
        d.print
        fast, rest = input_data.partition {|x| d.quickly_testable?(x)}
        puts "#{fast.size}/#{rest.size}"
      end

      puts "\nCUMULATIVE:\n\n"

      tail = input_data
      discriminators.each do |d|
        d.print
        fast, tail = tail.partition {|x| d.quickly_testable?(x)}
        puts "#{fast.size}/#{tail.size}"
      end


    end


  end

  class Processor4
    include Strategies
    include Report

    def initialize(csv_file_name = 'filtered2.csv')

      @input = []
      @candidates = []
      @discriminators = {}
      [5, 13,   19,   43,   61,   97,   157,   277].each do |p|
        @discriminators[p] = SumOfTwo6thPowerTermsModuloP_Discriminator.new p
      end

      @modulo_6th_roots_generators = { }

      [13,   19,   43,   61,   97,   157,   277].reverse_each do |p|
        @modulo_6th_roots_generators[p] = ModuloP6K6thRootsSE.new(p)
      end

      @modulo_6th_roots_generators[5] = ModuloK6thRoots.new(15625)

      CSV.foreach(csv_file_name, converters: :integer) do |row |
        @input << S6pHypothesis.from(*row)
      end
    end

    def input_data
      @input
    end

    def process

      rest = input_data

      puts "starting ..."

        processable_7, rest = rest.partition {|x| x % 7 == 1}
        processable_7.each  {|x| modulo7_res1_strategy(x) }



      @discriminators.each_pair do |p, d|

        fast, rest = rest.partition {|x| d.quickly_testable?(x)}
        p6pow = p**6

        fast.each do |h|
          modulo_p_6pow_divisibility_strategy(h,p,p6pow,@modulo_6th_roots_generators[p])
        end
      end



=begin
     Когда закомментирована обработка по 9 и 8
      candidates 6pow: 7308
      unprocessed: 38422

    + обработка по 9
     candidates 6pow: 37895
     unprocessed: 21104

    + обработка по 8

      candidates 6pow: 162417
      unprocessed: 13139

    Все равно тест на шестую занимает всего 0.17 секунд


=end
      processable_9, rest = rest.partition {|x| x % 9 == 1}
      processable_9.each {|x| modulo9_res1_strategy(x)}
# =begin

      processable_8, rest = rest.partition {|x| x % 8 == 1}
      processable_8.each {|x| modulo8_res1_strategy(x)}
# =end


      @unprocessed = rest

      @candidates.each do |h|
        puts "EUREKA" if is_sixth_power?(h)
      end

      sum_of_two_cubic_squares_check = SumOf2CubicSquaresFastChecker.new(2750171)

      puts "Quick-testing sum of two sixth powers"
      t = Benchmark.measure {
      @unprocessed = rest.select{|h| sum_of_two_cubic_squares_check.could_be? h.x}
      }
      puts t

      # erroneously
      # MAX_PRIME = 913247: 13139 => 5742 367 sec
      # MAX_PRIME = 224743 ; => 6051 122 sec
      # MAX_PRIME = 17393 ; => 6814 12 sec
      # MAX_PRIME = 2750171       => 5522 948 sec
      # MAX_PRIME = 12195263  => 5269  3520 sec


      CSV.open 'unprocessed2.csv', 'wb' do |csv|
        @unprocessed.each do |hyp|
          hyp.save(csv)
        end
      end


    end

    def report
      puts "INPUT: #{input_data.size}"
      puts "candidates 6pow: #{@candidates.size}"
      puts "unprocessed: #{@unprocessed.size}"
    end


    def is_sixth_power?(h)
      sixth_root=Math.cbrt(Math.sqrt(h.x))
      sixth_root.round ** 6 == h.x
    end


  end


  class Explorer2u
    include Report
    include Strategies
    def initialize(csv_file_name = 'unprocessed2.csv')
      @input = []

      CSV.foreach(csv_file_name, converters: :integer) do |row |
        @input << S6pHypothesis.from(*row)
      end
    end

    def input_data
      @input
    end

    def explore
      print_residues_stat(input_data,5)
      print_residues_stat(input_data,7)
      print_residues_stat(input_data,8)
      print_residues_stat(input_data,9)
      print_residues_stat(input_data,11)
      print_residues_stat(input_data,13)
      print_residues_stat(input_data,19)
      print_residues_stat(input_data,23)
      print_residues_stat(input_data,31)
      print_residues_stat(input_data,43)
      print_residues_stat(input_data,61)
      print_residues_stat(input_data,97)
      print_residues_stat(input_data,157)
      print_residues_stat(input_data,277)

    end

    def report

    end

  end



  end
