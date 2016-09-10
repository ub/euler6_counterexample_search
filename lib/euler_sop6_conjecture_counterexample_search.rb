require 'hypothesis'
module EulerSop6ConjectureCounterexampleSearch
  class StartHypothesesGenerator

    def generate
      (1...117649).each.lazy.select do |x|
        x % 2 != 0 &&
            x % 3 != 0 &&
            x % 7 != 0
      end.each do | x |
        Hypothesis.create(value: x**6, terms_count: 5, factor:1)
      end
    end
  end
end