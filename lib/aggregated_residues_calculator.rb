class AggregatedResiduesCalculator
  def initialize(p)
    @p = p

    @rs = (1...p).map { |x| x**6 % p }.to_a.sort.uniq

    @strict_agregated_residues =
    (2..4).map do |tc|
      @rs.repeated_combination(tc).map do |a|
        a.inject(&:+) % @p
      end.sort.uniq
    end
    @strict_agregated_residues = [nil,nil] + @strict_agregated_residues
  end

  #  power 6 residues in ordinarily sense
  def residues
    @rs
  end

  def singularity_residues(tc)
    all_strict = []
    tc.downto(2).each do |c |
      all_strict += @strict_agregated_residues[c]
    end
     @rs - all_strict.uniq
  end

  def strict_zero_aggregated_residues?(tc)
    all_strict = []
    tc.downto(2).each do |c |
      all_strict += @strict_agregated_residues[c]
    end
    return ! all_strict.include?( 0)
  end

  def report
    (2..4).each do|tc|
      puts "#{tc}: #{strict_zero_aggregated_residues?(tc) ? "0/" : ""} #{singularity_residues(tc).inspect}"
    end
  end
end


=begin
0:

7
31
67
79
139
223


Для трех членов  мы обнаруживаем 3,7 и 19 (1,7,11) имеют сингулярные вычеты --
т.е. если существование таких значений по модулю
которые имплицируют, что два из трех членов должны быть конгруэнтны нулю.

=end