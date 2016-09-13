require 'spec_helper'
require 'euler_sop6_conjecture_counterexample_search'

describe EulerSop6ConjectureCounterexampleSearch::Filter4 do
  let(:regression2a_bad) {FactoryGirl.build(:hypothesis,value:6456319701609065108594176,factor:117649)}
  it 'refutes value which is divisible by 8 but not 64' do
    expect(subject.filter([regression2a_bad])).to be_empty
    expect(regression2a_bad.refutation).to be_present
    expect(regression2a_bad.refutation.reload.hypothesis).to eq(regression2a_bad)
  end


end
