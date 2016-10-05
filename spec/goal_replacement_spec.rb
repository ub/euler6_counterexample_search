require 'rspec'
require 'spec_helper'
require 'goal_replacement'

describe GoalReplacement::Modulo_19_Tactic do

  describe '#match?' do
    let(:hyp4){FactoryGirl.build(:hypothesis, value:19**6 +1)}
    let(:bad_0)   {FactoryGirl.build(:hyp3, value:19**6 )}
    let(:good_1)   {FactoryGirl.build(:hyp3, value:19**6 +1)}
    let(:good_7)   {FactoryGirl.build(:hyp3, value:19**6 +7)}
    let(:good_11)  {FactoryGirl.build(:hyp3, value:19**6 +11)}
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
    let(:good_7)   {FactoryGirl.build(:hyp3, value:19**36 + 7)}
    let(:too_small_7)   {FactoryGirl.build(:hyp3, value:7)}

    # @period=47045881, @base_sequence=[8296659, 14558766, 22855425, 24190456, 32487115, 38749222]>
    it 'generates six hypotheses for (19**6)**6+7' do
      expect{|b|
        subject.apply(good_7, &b)
      }.to yield_control.exactly(6).times
    end

    it 'does not generate any hypotheses for too small a value' do
      expect{|b|
        subject.apply(too_small_7, &b)
      }.not_to yield_control

    end

  end

end