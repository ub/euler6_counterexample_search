class ModuloK6thRoots
  def initialize(k)
    @k = k
    lines = Array.new(k){[]}
    @k.times do |n|
      index = n**6 % @k
      next if index == 0
      lines[index] << n
    end
    @rows = lines.map {|base| PeriodicSequence.new(k, base)}
  end

  def [](i)
    @rows[i]
  end

  private


  class PeriodicSequence
    def initialize(period, base_sequence)
      @period, @base_sequence =
      period, base_sequence

    end

    def each
      if block_given?
        return if @base_sequence.empty?
        c = 0
        loop do
          @base_sequence.each do |x|
            yield x + c
          end
          c+=@period
        end
      else
        self.to_enum(:each)
      end
    end
  end

end