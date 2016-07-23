require 'rspec'

describe S6pHypothesis do
  subject(:irreducible) {S6pHypothesis.new(198,4)}
  subject(:irreducible8) {S6pHypothesis.new(200,4)}
  subject(:oddval) {S6pHypothesis.new(195,4)}
  subject {S6pHypothesis.new(192,4)}

  describe '#reduce_and_check' do
    it "reduces and passes" do
      result = subject.reduce_and_check(8,64)
      expect(result).to be_truthy
      expect(result.x).to eq 3
    end

    it "does not pass" do
      result=irreducible.reduce_and_check(8,64)
      expect(result).to be_falsey
    end

    it "does not pass" do
      result=irreducible8.reduce_and_check(8,64)
      expect(result).to be_falsey
    end

    it "passes" do
      result = oddval.reduce_and_check(8,64)
      expect(result).to be_truthy
    end

  end
end