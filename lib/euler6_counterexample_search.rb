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
        hypothesis = (v - u6).reduce_and_check(7, 117649)
        @candidates << hypothesis if hypothesis
      end
    end

    def modulo8_res1_strategy(v)
      @modulo64_6th_roots_generators ||= ModuloK6thRoots.new(64)
      res = v % 64
      @modulo64_6th_roots_generators[res].each do |u|
        u6 = u **6
        break if v < u6 # не годится для первого "гребня" f,e
        hypothesis = (v - u6).reduce_and_check(8, 64)
        @candidates << hypothesis if hypothesis
      end
    end

    def modulo9_res1_strategy(v)
      @modulo7649_6th_roots_generators ||= ModuloK6thRoots.new(729)
      res = v % 729
      @modulo7649_6th_roots_generators[res].each do |u|
        u6 = u **6
        break if v < u6 # не годится для первого "гребня" f,e
        hypothesis = (v - u6).reduce_and_check(9, 729)
        @candidates << hypothesis if hypothesis
      end
    end

    def modulo_p_6pow_divisibility_strategy(v, p, p6pow, modulo_p6pow_6th_roots_generators)
      res = v % p6pow
      modulo_p6pow_6th_roots_generators[res].each do |u|
        u6 = u **6
        break if v < u6
        hypothesis = (v - u6).reduce_and_check(p, p6pow)
        @candidates << hypothesis if hypothesis
      end
    end

    def brute_force_strategy(v)
      r7 = v % 7
      r8 = v % 8
      r9 = v % 9
      not7 = r7==v.terms_count
      oddonly = r8==v.terms_count
      not3 = r9==v.terms_count
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
      filtered = "%8d" %(numbers.count { |x| filter === x })
      l = "%6d" % k
      puts "#{l}: #{filtered}/#{total}"
    end

  end
  class Processor1
    def initialize(store_file_name)
      @modulo_p6pow_6th_roots_generators = ModuloK6thRoots.new(117649)
      @candidates = []
      @pstore = PStore.new(store_file_name)
    end

    def input_data
      (1...117649).each.lazy.select do |x|
        x % 2 != 0 &&
            x % 3 != 0 &&
            x % 7 != 0
      end.map { |x| x ** 6 }
    end

    def output
      @filtered
    end

    def process

      input_data.each do |f6|
        rem = f6 % 117649
        @modulo_p6pow_6th_roots_generators[rem].each do |e|
          e6=e**6
          break if e6 >= f6
          @candidates << S6pHypothesis.new((f6 - e6) /117649, 4, 117649)
        end

      end
      @filtered=@candidates.select { |x| x.reduce_and_check(8, 64) }.select { |x| x.reduce_and_check(9, 729) }.
          select { |x| x.reduce_and_check(7, 117649) }.select { |x| x.reduce_and_check(31, 887_503_681) }

      @pstore.transaction do
        @pstore[:candidates] = @candidates
        @pstore[:filtered] = @filtered
      end

    end

    def report
      puts
      puts @candidates.size
      puts @filtered.size
      print "FILT %9:"; p @filtered.group_by { |x| x % 9 }.map { |k, v| [k, v.size] }.sort
      print "FILT %8:"; p @filtered.group_by { |x| x % 8 }.map { |k, v| [k, v.size] }.sort
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
        rems = filtered.map { |x| x % k }.sort.uniq
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
        rems = filtered.map { |x| x % k }.sort.uniq
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

      processable_7, rest = input_data.partition { |x| x % 7 == 1 }

      processable_7.each { |x| modulo7_res1_strategy(x) }

      processable_9, rest = rest.partition { |x| x % 9 == 1 }
      processable_9.each { |x| modulo9_res1_strategy(x) }
      processable_8, rest = rest.partition { |x| x % 8 == 1 }
      processable_8.each { |x| modulo8_res1_strategy(x) }
      rest.each { |x| brute_force_strategy(x) }


      @pstore.transaction do
        @pstore[:candidates3] = @candidates
      end


    end

    def report_3(data)
      print_residues_stat(data, 7)
      print_residues_stat(data, 8)
      print_residues_stat(data, 9)
      print_residues_stat(data, 13)
      print_residues_stat(data, 17)
      print_residues_stat(data, 19)

      f19 = SumsOf6thPowerMTermsModK.new 19
      filtered = data.select { |x| f19 === x }
      puts filtered.size, data.size
    end

    def report
      puts "PROC2:", @candidates.size

      @filtered=@candidates.select { |x| x.reduce_and_check(8, 64) }
      puts "FILT2:", @filtered.size
      @filtered=@filtered.select { |x| x.reduce_and_check(9, 729) }
      puts "FILT3:", @filtered.size

      @filtered = @filtered.select { |x| x.reduce_and_check(7, 117649) }
      puts "FILT7:", @filtered.size

      print "FILT 31:"; p @filtered.group_by { |x| x % 31 }.map { |k, v| [k, v.size] }.sort

      @filtered = @filtered.select { |x| x.reduce_and_check(31, 887_503_681) }
      puts "FILT31:", @filtered.size

      f19 = SumsOf6thPowerMTermsModK.new 19
      @filtered = @filtered.select { |x| f19 === x }
      puts "FILT19:", @filtered.size

      print_residues_stat(@filtered, 7)
      print_residues_stat(@filtered, 8)
      print_residues_stat(@filtered, 9)
      print_residues_stat(@filtered, 13)
      print_residues_stat(@filtered, 17)

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

      print_residues_stat(data, 7)
      print_residues_stat(data, 8)
      print_residues_stat(data, 9)
      print_residues_stat(data, 13)
      print_residues_stat(data, 17)
      print_residues_stat(data, 19)

      print "PROCESSING ---"

      processable_7, rest = input_data.partition { |x| x % 7 == 1 }

      processable_7.each { |x| modulo7_res1_strategy(x) }
      puts "CAND SIZE: #{@candidates.size}"
      puts "REST SIZE: #{rest.size}"

      processable_9, rest = rest.partition { |x| x % 9 == 1 }
      processable_9.each { |x| modulo9_res1_strategy(x) }
      puts "CAND SIZE: #{@candidates.size}"
      puts "REST SIZE: #{rest.size}"
      processable_8, rest = rest.partition { |x| x % 8 == 1 }
      processable_8.each { |x| modulo8_res1_strategy(x) }
      puts "CAND SIZE: #{@candidates.size}"
      puts "REST SIZE: #{rest.size}"

      rest.each { |x| brute_force_strategy(x) }
      puts "CAND SIZE: #{@candidates.size}"


      @filtered=@candidates.select { |x| x.reduce_and_check(8, 64) }.select { |x| x.reduce_and_check(9, 729) }.
          select { |x| x.reduce_and_check(7, 117649) }.select { |x| x.reduce_and_check(31, 887_503_681) }

      _f5 = ~SumsOf6thPowerMTermsModK.new(5)
      _f13 = ~SumsOf6thPowerMTermsModK.new(13)
      _f19 = ~SumsOf6thPowerMTermsModK.new(19)
      _f37 = ~SumsOf6thPowerMTermsModK.new(37)
      _f43 = ~SumsOf6thPowerMTermsModK.new(43)
      _f61 = ~SumsOf6thPowerMTermsModK.new(61)
      _f67 = ~SumsOf6thPowerMTermsModK.new(67)
      _f73 = ~SumsOf6thPowerMTermsModK.new(73)
      _f79 = ~SumsOf6thPowerMTermsModK.new(79)

      puts "FILTERED: #{@filtered.size}"
      # Противоречие filter_report сообщает другие цифры
      @filtered = @filtered.reject do |x|
        case x
          when _f5, _f13, _f19, _f37, _f43, _f61, _f67, _f73, _f79, _f97
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

      CSV.foreach('filtered2.csv', converters: :integer) do |row|
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

      print_residues_stat(@input, 3)
      print_residues_stat(@input, 7)
      print_residues_stat(@input, 11)
      puts "..."
      print_residues_stat(@input, 13)
      puts "..."
      print_residues_stat(@input, 19)
      print_residues_stat(@input, 23)
      print_residues_stat(@input, 31)
      print_residues_stat(@input, 43)
      print_residues_stat(@input, 47)
      print_residues_stat(@input, 59)
      print_residues_stat(@input, 67)
      print_residues_stat(@input, 71)
      print_residues_stat(@input, 79)
      print_residues_stat(@input, 83)
      print_residues_stat(@input, 103)
      print_residues_stat(@input, 107)
      print_residues_stat(@input, 127)
      print_residues_stat(@input, 131)
      print_residues_stat(@input, 139)
      print_residues_stat(@input, 143)
      print_residues_stat(@input, 151)
      print_residues_stat(@input, 163)
      print_residues_stat(@input, 167)
      print_residues_stat(@input, 179)
      print_residues_stat(@input, 187)

      (191..3000).step(4) do |p|
        next unless Prime.prime?(p)
        print_residues_stat(@input, p)
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

      CSV.foreach(csv_file_name, converters: :integer) do |row|
        @input << S6pHypothesis.from(*row)
      end
    end

    def input_data
      @input
    end

    def explore_1mod7
      @modulo_p6pow_6th_roots_generators ||= ModuloK6thRoots.new(117649)
      print_residues_stat(input_data, 7)

      tm = Benchmark.measure {
        @candidates = []
        input_data.each do |h|
          next unless h % 7 == 1
          modulo7_res1_strategy(h)
        end
      }

      puts "COMBING: #{tm}"

      puts "candidates7 size: #{ @candidates.size}"

      tm1 = Benchmark.measure {
        @candidates.each do |h|
          ok=@candidates.any? { |h| sixth_root = ⁶ √ (h); sixth_root == sixth_root.to_i }
          puts("EUREKA!!! " * 6) if ok
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
      print_residues_stat(input_data, 7)
      print_residues_stat(input_data, 8)
      print_residues_stat(input_data, 9)
      print_residues_stat(input_data, 11)
      print_residues_stat(input_data, 5)
      print_residues_stat(input_data, 31)
      print_residues_stat(input_data, 13)
      print_residues_stat(input_data, 23)
      print_residues_stat(input_data, 19)

      @modulo_p6pow_6th_roots_generators ||= ModuloK6thRoots.new(117649)
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
                ok=@candidates.any? { |h| sixth_root = ⁶ √ (h); sixth_root == sixth_root.to_i }
                puts "candidates.size = #{@candidates.size }"
                puts("EUREKA!!! " * 6) if ok
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
        return true, index if p2 > test_value
        next unless p & 3 == 3

        while test_value % p == 0
          p6 = p2**3
          q, rem = test_value.divmod(p6)
          return false, index if rem != 0
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

      CSV.foreach(csv_file_name, converters: :integer) do |row|
        @input << S6pHypothesis.from(*row)
      end
    end

    def input_data
      @input
    end

    def explore

      discriminators = [5, 13, 19, 43, 61, 97, 157, 277].map do |p|
        SumOfTwo6thPowerTermsModuloP_Discriminator.new(p)
      end

      discriminators.each do |d|
        d.print
        fast, rest = input_data.partition { |x| d.quickly_testable?(x) }
        puts "#{fast.size}/#{rest.size}"
      end

      puts "\nCUMULATIVE:\n\n"

      tail = input_data
      discriminators.each do |d|
        d.print
        fast, tail = tail.partition { |x| d.quickly_testable?(x) }
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
      [5, 13, 19, 43, 61, 97, 157, 277].each do |p|
        @discriminators[p] = SumOfTwo6thPowerTermsModuloP_Discriminator.new p
      end

      @modulo_6th_roots_generators = {}

      [13, 19, 43, 61, 97, 157, 277].reverse_each do |p|
        @modulo_6th_roots_generators[p] = ModuloP6K6thRootsSE.new(p)
      end

      @modulo_6th_roots_generators[5] = ModuloK6thRoots.new(15625)

      CSV.foreach(csv_file_name, converters: :integer) do |row|
        @input << S6pHypothesis.from(*row)
      end
    end

    def input_data
      @input
    end

    def process

      rest = input_data

      puts "starting ..."

      processable_7, rest = rest.partition { |x| x % 7 == 1 }
      processable_7.each { |x| modulo7_res1_strategy(x) }


      @discriminators.each_pair do |p, d|

        fast, rest = rest.partition { |x| d.quickly_testable?(x) }
        p6pow = p**6

        fast.each do |h|
          modulo_p_6pow_divisibility_strategy(h, p, p6pow, @modulo_6th_roots_generators[p])
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
      processable_9, rest = rest.partition { |x| x % 9 == 1 }
      processable_9.each { |x| modulo9_res1_strategy(x) }
# =begin

      processable_8, rest = rest.partition { |x| x % 8 == 1 }
      processable_8.each { |x| modulo8_res1_strategy(x) }
# =end


      @unprocessed = rest

      @candidates.each do |h|
        puts "EUREKA" if is_sixth_power?(h)
      end

      sum_of_two_cubic_squares_check = SumOf2CubicSquaresFastChecker.new(2750171)

      puts "Quick-testing sum of two sixth powers"
      t = Benchmark.measure {
        @unprocessed = rest.select { |h| sum_of_two_cubic_squares_check.could_be? h.x }
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

      CSV.foreach(csv_file_name, converters: :integer) do |row|
        @input << S6pHypothesis.from(*row)
      end
    end

    def input_data
      @input
    end

    def explore
      print_residues_stat(input_data, 5)
      print_residues_stat(input_data, 7)
      print_residues_stat(input_data, 8)
      print_residues_stat(input_data, 9)
      print_residues_stat(input_data, 11)
      print_residues_stat(input_data, 13)
      print_residues_stat(input_data, 17)
      print_residues_stat(input_data, 19)
      #=> MODULO 19 residues:[[2, 425], [3, 306], [8, 357], [12, 297], [14, 480], [18, 317]]

      print_residues_stat(input_data, 23)
      print_residues_stat(input_data, 29)
      print_residues_stat(input_data, 31)
      print_residues_stat(input_data, 37)
      print_residues_stat(input_data, 43)
      print_residues_stat(input_data, 61)
      print_residues_stat(input_data, 97)
      print_residues_stat(input_data, 157)
      print_residues_stat(input_data, 277)
=begin
MODULO 5 residues:[[0, 827], [2, 716], [3, 639]]
MODULO 7 residues:[[2, 2182]]
MODULO 8 residues:[[2, 2182]]
MODULO 9 residues:[[2, 2182]]
MODULO 11 residues:[[1, 216], [2, 205], [3, 213], [4, 223], [5, 178], [6, 228], [7, 204], [8, 258], [9, 214], [10, 243]]
MODULO 13 residues:[[0, 973], [2, 622], [11, 587]]
MODULO 17 residues:[[0, 126], [1, 135], [2, 137], [3, 121], [4, 116], [5, 140], [6, 117], [7, 119], [8, 127], [9, 148], [10, 133], [11, 122], [12, 124], [13, 137], [14, 129], [15, 115], [16, 136]]
MODULO 19 residues:[[2, 425], [3, 306], [8, 357], [12, 297], [14, 480], [18, 317]]
MODULO 23 residues:[[1, 90], [2, 103], [3, 102], [4, 115], [5, 98], [6, 120], [7, 98], [8, 102], [9, 99], [10, 105],
                   [11, 84], [12, 99], [13, 121], [14, 102], [15, 95], [16, 93], [17, 86], [18, 110], [19, 94], [20, 71], [21, 97], [22, 98]]
MODULO 29 residues:[[0, 88], [1, 80], [2, 67], [3, 82], [4, 80], [5, 84], [6, 77], [7, 73], [8, 65], [9, 91], [10, 71],
                    [11, 78], [12, 74], [13, 84], [14, 73], [15, 68], [16, 61], [17, 65], [18, 80], [19, 77], [20, 66],
                    [21, 75], [22, 67], [23, 79], [24, 74], [25, 71], [26, 71], [27, 70], [28, 91]]
MODULO 31 residues:[[1, 118], [2, 139], [3, 142], [4, 114], [5, 178], [6, 161], [8, 147], [9, 131], [10, 139],
                    [12, 155], [16, 135], [17, 145], [18, 117], [20, 166], [24, 195]]
MODULO 37 residues:[[0, 207], [1, 147], [2, 70], [9, 88], [10, 154], [11, 126], [12, 107], [15, 83], [16, 108],
                    [17, 71], [20, 65], [21, 115], [22, 89], [25, 125], [26, 140], [27, 151], [28, 114], [35, 72], [36, 150]]

MODULO 43 residues:[[2, 84], [3, 120], [5, 86], [8, 73], [9, 155], [12, 76], [13, 87], [14, 120], [15, 124], [17, 130],
                    [19, 111], [20, 105], [22, 106], [25, 108], [27, 111], [32, 75], [33, 99], [36, 102], [37, 110], [39, 90], [42, 110]]

вычеты шестой степени по модулю 43 [1, 4, 11, 16, 21, 35, 41]
                    2 =  1+1 | 41 + 4
                    3 =  35 + 11
                    5 =  4 + 1
                    8 =  4 + 4 | 16 + 35
                    9 =  41 + 11
                    12 = 1 + 11
                    13 = 35 + 21
                    14 =  41 + 16
                    15 =  11 + 4
                    17 = 16 + 1
                    19 =  41+21
                    20 = 16 + 4
                    22 = 11 + 11
                    25 = 21 +4
                    27 = 16+11 | 35 + 35
                    32 = 21 + 11
                    33 = 35 + 41
                    36 = 35 + 1
                    37 = 21 + 16
                    39 = 35 +4 | 41 + 41
                    42 = 41 + 1



MODULO 61 residues:[[0, 77], [2, 60], [4, 53], [6, 42], [7, 61], [8, 54], [10, 70], [11, 55], [12, 73], [14, 60],
                    [17, 47], [18, 55], [19, 51], [21, 46], [23, 53], [24, 75], [25, 42], [26, 54], [28, 57], [29, 30],
                    [30, 63], [31, 45], [32, 49], [33, 57], [35, 55], [36, 43], [37, 58], [38, 39], [40, 58], [42, 59],
                    [43, 51], [44, 49], [47, 75], [49, 62], [50, 46], [51, 52], [53, 32], [54, 40], [55, 54], [57, 42], [59, 38]]
MODULO 97 residues:[[0, 38], [2, 22], [3, 20], [4, 16], [5, 27], [6, 51], [7, 18], [9, 40], [10, 26], [11, 32], [13, 28],
                    [14, 26], [15, 23], [16, 31], [17, 34], [19, 26], [20, 37], [21, 23], [23, 32], [24, 26], [25, 32],
                    [26, 31], [28, 27], [29, 26], [30, 14], [31, 30], [32, 33], [34, 35], [35, 29], [36, 15], [37, 28],
                    [38, 27], [39, 30], [40, 22], [41, 34], [42, 26], [43, 26], [44, 16], [45, 28], [46, 18], [48, 45],
                    [49, 36], [51, 24], [52, 42], [53, 22], [54, 24], [55, 22], [56, 21], [57, 33], [58, 24], [59, 24],
                    [60, 26], [61, 29], [62, 28], [63, 28], [65, 14], [66, 17], [67, 31], [68, 31], [69, 16], [71, 25],
                     [72, 20], [73, 32], [74, 29], [76, 17], [77, 26], [78, 26], [80, 38], [81, 21], [82, 23], [83, 34],
                     [84, 28], [86, 22], [87, 27], [88, 37], [90, 19], [91, 31], [92, 21], [93, 19], [94, 28], [95, 19]]
MODULO 157 residues:[[0, 23], [2, 17], [3, 14], [5, 12], [6, 21], [7, 17], [8, 18], [9, 19], [10, 13], [11, 10], [12, 15], [13, 18], [15, 23], [17, 20], [18, 11], [19, 10], [20, 21], [21, 10], [22, 7], [23, 21], [24, 28], [25, 17], [26, 21], [28, 19], [29, 13], [30, 16], [31, 24], [32, 18], [33, 13], [34, 12], [35, 11], [36, 17], [37, 19], [38, 22], [40, 15], [41, 26], [42, 21], [43, 15], [44, 14], [45, 18], [47, 20], [48, 8], [50, 14], [51, 17], [52, 14], [53, 16], [54, 19], [55, 20], [57, 13], [59, 16], [60, 23], [61, 14], [62, 15], [63, 16], [65, 13], [66, 17], [68, 22], [69, 14], [70, 4], [71, 20], [72, 26], [73, 16], [74, 23], [76, 12], [77, 11], [78, 14], [79, 10], [80, 8], [81, 19], [83, 22], [84, 16], [85, 20], [86, 13], [87, 18], [88, 11], [89, 15], [91, 25], [92, 15], [94, 21], [95, 19], [96, 17], [97, 17], [98, 15], [100, 18], [102, 17], [103, 19], [104, 8], [105, 16], [106, 8], [107, 9], [109, 20], [110, 11], [112, 20], [113, 21], [114, 15], [115, 13], [116, 17], [117, 24], [119, 13], [120, 8], [121, 30], [122, 16], [123, 17], [124, 18], [125, 18], [126, 18], [127, 13], [128, 19], [129, 23], [131, 19], [132, 15], [133, 16], [134, 21], [135, 5], [136, 28], [137, 16], [138, 19], [139, 15], [140, 18], [142, 21], [144, 19], [145, 19], [146, 16], [147, 14], [148, 22], [149, 12], [150, 10], [151, 12], [152, 14], [154, 20], [155, 25]]
MODULO 277 residues:[[0, 11], [2, 7], [3, 9], [5, 15], [6, 7], [7, 6], [8, 12], [9, 7], [10, 11], [11, 9], [12, 8], [14, 11], [15, 7], [17, 12], [18, 10], [20, 9], [22, 12], [23, 11], [24, 12], [25, 6], [26, 4], [28, 11], [29, 10], [31, 9], [32, 8], [33, 8], [34, 16], [35, 7], [36, 9], [37, 23], [38, 8], [39, 8], [40, 11], [42, 9], [43, 5], [44, 18], [45, 15], [46, 12], [47, 7], [48, 14], [49, 13], [50, 5], [51, 6], [53, 7], [54, 10], [55, 12], [56, 8], [57, 8], [58, 13], [60, 3], [61, 5], [62, 13], [63, 8], [65, 12], [67, 8], [68, 16], [70, 5], [71, 7], [72, 9], [73, 9], [75, 13], [77, 8], [78, 8], [79, 7], [80, 23], [81, 6], [82, 3], [83, 8], [85, 10], [86, 10], [87, 12], [88, 18], [89, 10], [90, 13], [91, 10], [92, 9], [93, 6], [94, 13], [95, 9], [96, 9], [97, 7], [98, 13], [99, 10], [100, 8], [101, 11], [103, 9], [104, 3], [105, 12], [106, 8], [107, 12], [109, 13], [110, 7], [111, 11], [112, 10], [114, 6], [115, 5], [116, 11], [117, 11], [118, 6], [119, 7], [121, 11], [123, 9], [124, 17], [125, 15], [126, 12], [127, 12], [128, 9], [129, 9], [130, 11], [132, 2], [133, 14], [134, 11], [135, 11], [136, 11], [137, 12], [138, 5], [139, 12], [140, 6], [141, 12], [142, 7], [143, 7], [144, 8], [145, 11], [147, 11], [148, 9], [149, 9], [150, 15], [151, 9], [152, 7], [153, 8], [154, 7], [156, 6], [158, 12], [159, 7], [160, 6], [161, 15], [162, 12], [163, 9], [165, 11], [166, 13], [167, 7], [168, 13], [170, 8], [171, 4], [172, 9], [173, 11], [174, 6], [176, 12], [177, 10], [178, 11], [179, 13], [180, 16], [181, 8], [182, 7], [183, 5], [184, 16], [185, 6], [186, 9], [187, 10], [188, 9], [189, 6], [190, 5], [191, 9], [192, 6], [194, 10], [195, 8], [196, 11], [197, 11], [198, 5], [199, 4], [200, 3], [202, 8], [204, 11], [205, 14], [206, 6], [207, 11], [209, 11], [210, 9], [212, 8], [214, 11], [215, 8], [216, 7], [217, 15], [219, 10], [220, 7], [221, 10], [222, 8], [223, 8], [224, 14], [226, 10], [227, 10], [228, 12], [229, 13], [230, 7], [231, 7], [232, 5], [233, 7], [234, 5], [235, 8], [237, 2], [238, 4], [239, 12], [240, 9], [241, 11], [242, 6], [243, 13], [244, 5], [245, 11], [246, 9], [248, 9], [249, 4], [251, 9], [252, 4], [253, 12], [254, 15], [255, 9], [257, 10], [259, 16], [260, 7], [262, 14], [263, 3], [265, 9], [266, 9], [267, 15], [268, 9], [269, 5], [270, 8], [271, 6], [272, 10], [274, 18], [275, 5]]

=end

    end

    def report

    end

  end


  class Processor5

    include Report
    include Strategies

    def initialize(csv_file_name = 'unprocessed2.csv')
      @input = []
      @candidates = []


      CSV.foreach(csv_file_name, converters: :integer) do |row|
        @input << S6pHypothesis.from(*row)
      end
    end

    def input_data
      @input
    end

    def process

      # На генерацию 1 227 535 кандидатов ушло меньше 3 секунд --  долгий отсев 4k+3 на предыдущем шаге
      # неоптимален?
      input_data.each { |x| brute_force_strategy(x) }

      # И проверка завершилась за ~1.5 секунды
      @candidates.each do |h|
        puts "EUREKAAA!!!" if is_sixth_power? h
      end


    end

    def report

      puts "CANDIDATES: #{@candidates.size}"

      p @candidates.first

      puts is_sixth_power? @candidates.first

    end

    #FIXME DRY
    def is_sixth_power?(h)
      sixth_root=Math.cbrt(Math.sqrt(h.x))
      sixth_root.round ** 6 == h.x
    end


  end


end
