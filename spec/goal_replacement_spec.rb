require 'rspec'
require 'spec_helper'
require 'pregeneration_filters'
require 'goal_replacement'

describe GoalReplacement::Modulo_19_Tactic do
  describe '#match?' do
    let(:hyp4){ FactoryGirl.build(:hypothesis, value: 19**6 + 1) }
    let(:bad_0)   { FactoryGirl.build(:hyp3, value: 19**6 ) }
    let(:good_1)   { FactoryGirl.build(:hyp3, value: 19**6 + 1) }
    let(:good_7)   { FactoryGirl.build(:hyp3, value: 19**6 + 7) }
    let(:good_11)  { FactoryGirl.build(:hyp3, value: 19**6 + 11) }
    it 'does not accept hypothesis with 4 terms' do
      expect(subject.match?(hyp4)).to be_falsey
    end

    it 'does accept residue-congruent 3-term hypothesis' do
      expect(subject.match?(good_1)).to be_truthy
      expect(subject.match?(good_7)).to be_truthy
      expect(subject.match?(good_11)).to be_truthy
    end

    it 'does not accept zero-congruent' do
      expect(subject.match?(bad_0)).to be_falsey
    end
  end

  describe '#apply' do
    let(:good_7)   { FactoryGirl.build(:hyp3, value: 19**36 + 7) }
    let(:too_small_7)   { FactoryGirl.build(:hyp3, value: 7) }

    # @period=47045881,
    # @base_sequence=[8296659, 14558766, 22855425, 24190456, 32487115, 38749222]>
    it 'generates six hypotheses for (19**6)**6+7' do
      expect{ |b|
        subject.apply(good_7, &b)
      }.to yield_control.exactly(6).times
    end

    it 'does not generate any hypotheses for too small a value' do
      expect{ |b|
        subject.apply(too_small_7, &b)
      }.not_to yield_control
    end
  end
end

describe GoalReplacement::TwoTermsAllButOneTermDivisibleBy_p_Tactic do
  context 'modulo 5' do
    let(:match1) { FactoryGirl.build(:hyp2, value: 5**6 + 1) }
    let(:match_1) { FactoryGirl.build(:hyp2, value: 5**6 + 3**6) }
    let(:nomatch_0) { FactoryGirl.build(:hyp2, value: 5**6 ) }
    let(:nomatch_2) { FactoryGirl.build(:hyp2, value: 1 + 6**6 ) }
    let(:nomatch_3) { FactoryGirl.build(:hyp2, value: 2**6 + 3**6 ) }

    subject { GoalReplacement::TwoTermsAllButOneTermDivisibleBy_p_Tactic.new 5 }

    describe '#match?' do
       it 'matches modulo +-1' do
         expect(subject.match?(match1)).to be_truthy
         expect(subject.match?(match_1)).to be_truthy
       end

       it 'does not match non-residues' do
         expect(subject.match?(nomatch_0)).to be_falsey
         expect(subject.match?(nomatch_2)).to be_falsey
         expect(subject.match?(nomatch_3)).to be_falsey
       end
    end

    describe '#apply' do
      it 'generates the only possible hypothesis for 1 residue example' do
        expect{ |b|
          subject.apply(match1, &b)
        }.to yield_control.once

        expect{ |b|
          subject.apply(match1, &b)
        }.to yield_with_args(an_object_having_attributes(value: 1, factor: 5**6, terms_count: 1))
      end

      it 'generates the only possible hypothesis for -1 residue example' do
        expect{ |b|
          subject.apply(match_1, &b)
        }.to yield_control.once

        expect{ |b|
          subject.apply(match1, &b)
        }.to yield_with_args(an_object_having_attributes(value: 1, factor: 5**6, terms_count: 1))
      end
    end
  end
  context 'modulo 43' do
    #[1, 4, 11, 16, 21, 35, 41]
    let(:match1) { FactoryGirl.build(:hyp2, value: 6**6 + 5 * 43**6 ) }
     let(:match41) { FactoryGirl.build(:hyp2, value:   3**6 + 43**6) }
    let(:nomatch_0) { FactoryGirl.build(:hyp2, value: 4 * 43**6 ) }
     let(:nomatch_2) { FactoryGirl.build(:hyp2, value: 7**6 + 6**6 ) }

    subject { GoalReplacement::TwoTermsAllButOneTermDivisibleBy_p_Tactic.new 43 }

    describe '#match?' do
       it 'matches modulo 1' do
         expect(subject.match?(match1)).to be_truthy
         expect(subject.match?(match41)).to be_truthy
       end

       it 'does not match non-residues' do
         expect(subject.match?(nomatch_0)).to be_falsey
         expect(subject.match?(nomatch_2)).to be_falsey
       end
    end

    describe '#apply' do
      it 'generates the only possible hypothesis for 1 residue example' do
        expect{ |b|
          subject.apply(match1, &b)
        }.to yield_control.once

        expect{ |b|
          subject.apply(match1, &b)
        }.to yield_with_args(an_object_having_attributes(value: 5, factor: 43**6, terms_count: 1))
      end

      it 'generates the only possible hypothesis for 41 residue example' do
        expect{ |b|
          subject.apply(match41, &b)
        }.to yield_control.once

        expect{ |b|
          subject.apply(match41, &b)
        }.to yield_with_args(an_object_having_attributes(value: 1, factor: 43**6, terms_count: 1))
      end
    end
  end
end
