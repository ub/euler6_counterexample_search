require 'spec_helper'
require 'pp'

class ModuloP6K6thRootsSE
  def roots_stat
    @sixth_roots_mod_p.map(&:size).uniq
  end
end

describe ModuloP6K6thRootsSE do
  subject {ModuloP6K6thRootsSE.new(7)}
  it {is_expected.to be}
  describe "#[]" do
    it 'unique roots are well-known' do
     expect(subject[1].each.take(6)).to contain_exactly(1, 34967, 34968, 82681, 82682, 117648)
    end
  end

  xdescribe 'explorative stuff, not real BDD specs ' do
    specify  do
      @roots_mod_277_pow_6 = ModuloP6K6thRootsSE.new(277)
      @roots_mod_5_pow_6 = ModuloP6K6thRootsSE.new(5)

      [11, 17, 19, 7, 9, 5, 8, 43, 13, 277, 61, 97, 157].each do |m|
        p m
        mm = ModuloP6K6thRootsSE.new m
        pp mm.roots_stat

      end

        puts "well"

    end
  end

end