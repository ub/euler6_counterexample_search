require 'rspec'
require 'spec_helper'

describe Hypothesis do

  it 'should be able to create itself peacefully' do

    h = Hypothesis.create(value: 2**50,terms_count: 5, factor:'1')
    id = h.id
    expect{ h.save! }.not_to raise_exception
    h1 = Hypothesis.find(id)
    expect(h1.value.to_i).to eq(2**50)
  end
end
