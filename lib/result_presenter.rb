class ResultPresenter
  def extract_terms(s)
    terms = [s.root]
    h = s.hypothesis
    while h.parent_id
      f = sxrt h.factor
      terms.map! { |x| x * f }
      term6 = h.parent.x - (h.x * h.factor)
      term = sxrt term6
      terms << term
      h = h.parent
    end
    terms
  end

  def original(s)
    h = s.hypothesis
    h = h.parent while h.parent_id
    h.x
  end

  def check(terms, sum6pow)
    terms.map { |x| x**6 }.reduce(&:+) == sum6pow
  end

  def display_s(terms, sum6pow)
    terms.sort.map { |t| "#{t}⁶" }.join(" + ") + " = #{sum6pow}"
  end

  private
  #FIXME Approximation!
  def sxrt(x)
    Math.cbrt(Math.sqrt x).round
  end
end
