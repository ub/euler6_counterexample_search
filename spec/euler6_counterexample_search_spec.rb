require 'spec_helper'

describe Euler6CounterexampleSearch do
  it 'does something useful'
end


describe ModuloK6thRoots do
  describe '.new' do
    it 'creates instance' do
      modulo117649_6th_roots_generator = ModuloK6thRoots.new(117649)
      expect(modulo117649_6th_roots_generator).to be
    end
  end

  describe '#[]' do
    subject(:modulo117649_6th_roots_generators) { ModuloK6thRoots.new(117649) }
    context '#[1]' do
      subject {modulo117649_6th_roots_generators[1].each}
      it {is_expected.to include(1)}
      it {is_expected.to include(117648)}
      it {is_expected.to include(117650)}
    end
    context '#[64]' do
      subject {modulo117649_6th_roots_generators[64].each}
      it {is_expected.to include(2)}
    end
    context '#[729]' do
      subject {modulo117649_6th_roots_generators[729].each}
      it {is_expected.to include(3)}
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
