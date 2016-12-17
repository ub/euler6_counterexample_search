require 'spec_helper'

describe Modulo64_Roots_512_lookahead do

  let(:ex_a) { FactoryGirl.create(:hyp3,value:2**54 + 0b101_110_001) }
  it 'has 12 candidates below 512 ' do
    expect(subject[ex_a].each.take(12)).to all(be < 512)
  end

  it 'difference between ex_a and candidates raised to 6th power is congruent to 0 mod 64' do

    diffs = subject[ex_a].each.take(12).map do |u|
      ex_a.value - u**6
    end
    expect(diffs.map{ |x| x % 64 }).to all(be_zero)
  end

  it 'after reduction by 64 modulo 8 is less than 3' do
    diffs = subject[ex_a].each.take(12).map do |u|
      ex_a.value - u**6
    end
    expect(diffs.map{ |x| (x / 64) % 8 }).to all(be < 3)
    expect(diffs.map{ |x| (x / 64) % 8 }).to contain_exactly  0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2

  end

end