require 'spec_helper'

describe Euler6CounterexampleSearch do
  it 'does something useful'

end
describe Euler6CounterexampleSearch::Processor1 do

  subject { Euler6CounterexampleSearch::Processor1.new 'euler6_hypotheses.pstore' }
  it 'provides input data of pseudo 6th powers' do
    expect(subject.input_data.count).to eq 117649 * 2 /7
  end

  it 'works' do
    expect { subject.process()
    ; subject.report

    }.not_to raise_exception
  end

end


describe Euler6CounterexampleSearch::Processor2 do

  subject { Euler6CounterexampleSearch::Processor2.new 'euler6_hypotheses.pstore' }

  it 'works' do
    expect { subject.process()
    ; subject.report

    }.not_to raise_exception
  end

end

describe Euler6CounterexampleSearch::Processor3 do

  subject { Euler6CounterexampleSearch::Processor3.new 'euler6_hypotheses.pstore' }

  it 'works' do
    expect { subject.process()
    ; # subject.report

    }.not_to raise_exception
  end

end

describe Euler6CounterexampleSearch::Explorer3 do

  subject { Euler6CounterexampleSearch::Explorer3.new 'euler6_hypotheses.pstore' }

  it 'works' do
    expect { subject.explore; # subject.report

    }.not_to raise_exception
  end

end

describe Euler6CounterexampleSearch::Explorer2 do


  it 'works' do
    expect { subject.explore; # subject.report

    }.not_to raise_exception
  end

end
xdescribe Euler6CounterexampleSearch::Explorer2a do


  it 'works' do
    expect { subject.explore; # subject.report

    }.not_to raise_exception
  end

end



describe Euler6CounterexampleSearch::Processor4 do

  # subject { Euler6CounterexampleSearch::Processor4.new  }

  it 'works' do
    expect { subject.process;  subject.report

    }.not_to raise_exception
  end

end

describe Euler6CounterexampleSearch::Explorer2u do

  it 'works' do
    expect { subject.explore;  subject.report

    }.not_to raise_exception
  end

end


describe Euler6CounterexampleSearch::Processor5 do


  it 'works' do
    expect { subject.process;  subject.report

    }.not_to raise_exception
  end

end



describe SumsOf6thPowerMTermsModK do
  describe '.new' do
    it 'creates instance' do
      constraint = SumsOf6thPowerMTermsModK.new(13)
      expect(constraint).to be
    end
  end

  describe '#[]' do
    subject(:sum_of_6th_powers_mod13) { SumsOf6thPowerMTermsModK.new(13) }
    context 'for 1 term' do
      let(:x_pow6_mod13_valueset) { sum_of_6th_powers_mod13[1] }
      specify { expect(x_pow6_mod13_valueset).to contain_exactly(0, 1, 12) }
    end
    context 'for 2 terms' do
      let(:two_terms_valueset) { sum_of_6th_powers_mod13[2] }
      specify { expect(two_terms_valueset).to contain_exactly(0, 1, 2, 11, 12) }
    end

    context 'for 3 terms' do
      let(:three_terms_valueset) { sum_of_6th_powers_mod13[3] }
      specify { expect(three_terms_valueset).to contain_exactly(0, 1, 2, 3, 10, 11, 12) }
    end
  end

  describe '#~' do
    subject(:sum_of_6th_powers_mod13) { SumsOf6thPowerMTermsModK.new(13) }
    subject(:sum_of_6th_powers_mod31) { SumsOf6thPowerMTermsModK.new(31) }
    context 'for 4 terms' do
      let(:four_terms) { (~sum_of_6th_powers_mod13)[4] }
      specify { expect(four_terms).to contain_exactly *(5..8) }
    end

    let (:inverted_sum_of_6th_powers_mod31) { ~sum_of_6th_powers_mod31 }
    let(:all31) { 0...31 }
    it 'complements values of the operand' do
      (1..4).each do |m|
        expect(sum_of_6th_powers_mod31[m] | inverted_sum_of_6th_powers_mod31[m]).to contain_exactly *all31
        expect(sum_of_6th_powers_mod31[m] & inverted_sum_of_6th_powers_mod31[m]).to be_empty

      end
    end


  end

  describe '#===' do
    subject(:sums_of_6th_powers_mod13) { SumsOf6thPowerMTermsModK.new(13) }
    let(:zero) { S6pHypothesis.new(0, 1) }
    let(:_14) { S6pHypothesis.new(14, 1) }

    it 'contains zero' do
      expect(sums_of_6th_powers_mod13 === zero).to be_truthy
    end
    it 'matches 14 (congruent to 1)' do
      expect(sums_of_6th_powers_mod13 === _14).to be_truthy
    end

  end


end


describe ModuloP6K6thRootsSE do
  describe '.new' do
    it 'creates instance' do
      modulo117649_6th_roots_generator = ModuloP6K6thRootsSE.new(7)
      expect(modulo117649_6th_roots_generator).to be
    end
  end

  describe '#[]' do
    let(:modulo117649_6th_roots_generator) { ModuloK6thRoots.new(117649) }
    let(:modulo117649_6th_roots_generator_se) { ModuloP6K6thRootsSE.new(7) }
    let(:modulo729_6th_roots_generator) { ModuloK6thRoots.new(729) }
    let(:modulo729_6th_roots_generator_se) { ModuloP6K6thRootsSE.new(3) }
    # let(:modulo4826809_6th_roots_generator) { ModuloK6thRoots.new(4826809) }
    # let(:modulo4826809_6th_roots_generator_se) { ModuloK6RootsSE.new(13) }
    it 'produces same results as manually calculated table for 7⁶' do
      (1..117649).step(7) do |r|
        expect(modulo117649_6th_roots_generator_se[r].each.take(6)).to eq(
               modulo117649_6th_roots_generator[r].each.take(6))

      end
    end


  end

end


fdescribe ModuloK6thRoots do
  describe '.new' do
    it 'creates instance' do
      modulo117649_6th_roots_generator = ModuloK6thRoots.new(117649)
      expect(modulo117649_6th_roots_generator).to be
    end
  end

  describe '#[]' do
    subject(:modulo_p6pow_6th_roots_generators) { ModuloK6thRoots.new(117649) }
    context '#[1]' do
      subject { modulo_p6pow_6th_roots_generators[1].each }
      it { is_expected.to include(1) }
      it { is_expected.to include(117648) }
      it { is_expected.to include(117650) }
    end
    context '#[64]' do
      subject { modulo_p6pow_6th_roots_generators[64].each }
      it { is_expected.to include(2) }
    end
    context '#[729]' do
      subject { modulo_p6pow_6th_roots_generators[729].each }
      it { is_expected.to include(3) }
    end
  end

  describe '#is_root?' do
    subject(:mod7rootgen) {ModuloK6thRoots.new 7}
    it ' non-divisible by 7 numbers are roots of 1' do
      expect(mod7rootgen.is_root?(1,1)).to be_truthy
      expect(mod7rootgen.is_root?(9,1)).to be_truthy
      expect(mod7rootgen.is_root?(2,1)).to be_truthy
      expect(mod7rootgen.is_root?(3,1)).to be_truthy
      expect(mod7rootgen.is_root?(4,1)).to be_truthy
      expect(mod7rootgen.is_root?(5,1)).to be_truthy
      expect(mod7rootgen.is_root?(13,1)).to be_truthy
    end

    it ' divisible  7 numbers are not roots of 1' do
      expect(mod7rootgen.is_root?(0,1)).to  be_falsey
      expect(mod7rootgen.is_root?(14,1)).to be_falsey
      expect(mod7rootgen.is_root?(7,1)).to  be_falsey
    end

    it 'there are no roots of 2' do
      expect(mod7rootgen.is_root?(0,2)).to be_falsey
      expect(mod7rootgen.is_root?(1,2)).to be_falsey
      expect(mod7rootgen.is_root?(2,2)).to be_falsey
      expect(mod7rootgen.is_root?(3,2)).to be_falsey
      expect(mod7rootgen.is_root?(4,2)).to be_falsey
      expect(mod7rootgen.is_root?(5,2)).to be_falsey
      expect(mod7rootgen.is_root?(6,2)).to be_falsey
    end

  end


end

describe ModuloK6thRoots::PeriodicSequence do
  let(:period) { 10 }
  let(:base_sequence) { [1, 2, 3] }
  subject(:gen10) { ModuloK6thRoots::PeriodicSequence.new(period, base_sequence) }
  describe '.new'
  it 'creates instance' do
    expect(gen10).to be
  end

  describe '#each' do
    it 'creates enumerator' do
      expect(gen10.each).to be_a_kind_of(Enumerator)
    end

    it 'produces original sequence' do
      expect(gen10.each.take(base_sequence.length)).to eq(base_sequence)
    end

    it 'produces  list of double length' do
      expect(gen10.each.take(base_sequence.length * 2)).to eq([1, 2, 3, 11, 12, 13])
    end

    it 'produces  list of arbitrary length' do
      expect(gen10.each.take(base_sequence.length * 3 + 1)).to eq([1, 2, 3, 11, 12, 13, 21, 22, 23, 31])
    end

    context 'empty base' do
      subject(:empty) { ModuloK6thRoots::PeriodicSequence.new(1, []) }
      it 'produces only empty lists' do
        expect(empty.each.take(10)).to be_empty
      end
      it 'iterator is empty' do
        expect(empty.each.to_a).to be_empty
      end
    end
  end
end


describe SumOf2CubicSquaresFastChecker do
  describe 'could?' do
    let(:too_large_factor) { 913259 ** 2 }

    it 'accepts numbers with prime factors like 4k+1' do
      expect(subject.could_be?(5)).to be_truthy
      expect(subject.could_be?(25)).to be_truthy
      expect(subject.could_be?(13)).to be_truthy
      expect(subject.could_be?(65)).to be_truthy
    end

    it 'rejects numbers with prime factors like 4k+3 of 1st power' do
      expect(subject.could_be?(913247)).to be_falsey
      expect(subject.could_be?(7)).to be_falsey
    end

    it 'rejects numbers with prime factors like 4k+3 squared ' do
      expect(subject.could_be?(49)).to be_falsey
      expect(subject.could_be?(19**2)).to be_falsey
      expect(subject.could_be?(19*49)).to be_falsey
    end

    it 'accepts numbers with prime factors like 4k+3 raised to sixth power ' do
      expect(subject.could_be?(7**6)).to be_truthy
      expect(subject.could_be?(19**6)).to be_truthy
      expect(subject.could_be?(19**6 * 7**6)).to be_truthy
    end

    it 'accepts numbers with prime factors like 4k+3 raised to twelveth power ' do
      expect(subject.could_be?(7**12)).to be_truthy
    end

    it 'rejects numbers with prime factors like 4k+3 raised to 7th power ' do
      expect(subject.could_be?(7**7)).to be_falsey
    end






    it 'does not check too large prime  and returns false positive' do
      expect(subject.could_be?(too_large_factor)).to be_truthy
    end

  end
end


