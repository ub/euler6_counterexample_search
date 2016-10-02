require 'spec_helper'
require 'filtering_rules'
require 'refutation'

describe FilteringRules::DivisibilityBy_p_ImpliesDivisibilityBy_p_6 do

  let (:good3_a) {FactoryGirl.create(:hyp3,value:5 ** 6 + 7 **6 + 11**6)}
  let (:bad3_5) {FactoryGirl.create(:hyp3,value:3**5)}
  let (:good3_7) {FactoryGirl.create(:hyp3, value:3**7)}
  let (:bad3_8) {FactoryGirl.create(:hyp3,value:3**8)}
  let (:refutations) {[]}
  let (:modifications) {[]}
  subject(:div729_checker){FilteringRules::DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(3)}
  subject(:div64_checker){FilteringRules::DivisibilityBy_p_ImpliesDivisibilityBy_p_6.new(2)}

  let(:regression2a_bad) {FactoryGirl.build(:hypothesis,value:100879995337641642321784)}

  it 'accepts sum of three 6th powers (regression)' do
    expect(div729_checker.check(good3_a, refutations, modifications)).to be_truthy
    expect(good3_a.refutation).to be_blank
    expect(refutations).to be_empty
  end

  it 'does not add persisted hypothesis to modification list when not factoring out a 6th power' do
    div729_checker.check(good3_a, refutations, modifications)
    expect(modifications).to be_empty
  end


  it 'refutes 3**5' do
    expect(div729_checker.check(bad3_5, refutations, modifications)).to be_falsey
    expect(bad3_5.refutation).to be_present
    expect(refutations).to contain_exactly bad3_5.refutation
    expect(modifications).to be_empty
  end

  it 'accepts 3**7' do
    expect(div729_checker.check(good3_7, refutations, modifications)).to be_truthy
  end

  it 'modifies (reduces) 3**7' do
    div729_checker.check(good3_7, refutations, modifications)
    expect(modifications).to contain_exactly good3_7
    expect(good3_7).to be_changed
    expect(good3_7.x).to eq 3
    expect(good3_7.factor).to eq 729
  end


  it 'refutes 3**8' do
    expect(div729_checker.check(bad3_8, refutations, modifications)).to be_falsey
    expect(bad3_8.refutation).to be_present
    expect(refutations).to contain_exactly bad3_8.refutation
  end
  it 'modifies (reduces) 3**8' do
    div729_checker.check(bad3_8, refutations, modifications)
    expect(modifications).to contain_exactly bad3_8
    expect(bad3_8).to be_changed
    expect(bad3_8.x).to eq 9
    expect(bad3_8.factor).to eq 729
  end


  it 'refuses regression 1 example ' do

    expect(div64_checker.check(regression2a_bad, refutations, modifications)).to be_falsey
    expect(regression2a_bad.refutation).to be_present
    expect(regression2a_bad.refutation.hypothesis).to eq(regression2a_bad)
  end

describe FilteringRules::RemainderIsRepresentableAsSumOf6powResidues do

  it 'should do something'

end
end
