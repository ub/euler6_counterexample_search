require 'spec_helper'
require 'filtering_rules'
require 'refutation'

describe FilteringRules::DivisibilityBy_p_ImpliesDivisibilityBy_p_6 do

  let (:good3_a) {Hypothesis.new(value:5 ** 6 + 7 **6 + 11**6,terms_count: 3,factor:1)}
  let (:bad3_5) {Hypothesis.new(value:3**5,terms_count: 3,factor:1)}
  let (:bad3_7) {Hypothesis.new(value:3**7,terms_count: 3,factor:1)}
  subject(:div729_checker){FilteringRules::DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(3)}

  it 'marks posititve sum of three 6th powers (regression)' do
    expect(div729_checker.check(good3_a)).to be_truthy
    expect(good3_a.refutation).to be_blank
    r = Refutation.first
    p r
    expect( Refutation.count).to be_zero
  end

  it 'marks negative 3**5' do
    expect(div729_checker.check(bad3_5)).to be_falsey
    expect(bad3_5.refutation).to be_present
  end

describe FilteringRules::RemainderIsRepresentableAsSumOf6powResidues do

  it 'should do something'

end
end
