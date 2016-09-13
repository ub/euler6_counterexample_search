require 'spec_helper'
require 'filtering_rules'
require 'refutation'

describe FilteringRules::DivisibilityBy_p_ImpliesDivisibilityBy_p_6 do

  let (:good3_a) {FactoryGirl.build(:hyp3,value:5 ** 6 + 7 **6 + 11**6)}
  let (:bad3_5) {FactoryGirl.build(:hyp3,value:3**5)}
  let (:bad3_7) {FactoryGirl.build(:hyp3,value:3**7)}
  subject(:div729_checker){FilteringRules::DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(3)}
  subject(:div64_checker){FilteringRules::DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(2)}

  let(:regression2a_bad) {FactoryGirl.build(:hypothesis,value:100879995337641642321784)}

  it 'marks posititve sum of three 6th powers (regression)' do
    expect(div729_checker.check(good3_a)).to be_truthy
    expect(good3_a.refutation).to be_blank
    r = Refutation.first
  end

  it 'marks negative 3**5' do
    expect(div729_checker.check(bad3_5)).to be_falsey
    expect(bad3_5.refutation).to be_present
  end

  it 'refuses regression 1 example ' do

    expect(div64_checker.check(regression2a_bad)).to be_falsey
    expect(regression2a_bad.refutation).to be_present
    expect(regression2a_bad.refutation.reload.hypothesis).to eq(regression2a_bad)
  end

describe FilteringRules::RemainderIsRepresentableAsSumOf6powResidues do

  it 'should do something'

end
end
