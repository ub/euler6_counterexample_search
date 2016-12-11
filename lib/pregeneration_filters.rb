module PregenerationFilters
  class Null
    def self.with(_)
      yield self
    end
    def self.rejects?(_)
      false
    end
  end
  class ResiduesExclusions
    def initialize(p,n_terms)
      @p, @n_terms = p, n_terms
      aggr_calc = N_TermsAggregatedResiduesConstraintsCalc.new(p, n_terms)
      @exclusions_map = aggr_calc.exclusions
      @roots_generator=ModuloK6thRoots.new(p)
    end

    def residue(v)
      v % @p
    end

    def modulo
      @p
    end

    def rejects?(aggregated_residue, u)
      exclusions = Array(@exclusions_map[aggregated_residue])
      return false if exclusions.empty?
      exclusions.any? do |forbidden|
        @roots_generator.is_root?(u, forbidden )
      end
    end
  end

  class MultiModuloResidueExclusions
    class FilterSet
      def initialize(zipped)
        @filters_with_aggregated_residues = zipped
      end

      def rejects?(u)
        @filters_with_aggregated_residues.any? do | f,  ar|
          f.rejects?(ar,u)
        end
      end

    end
    def initialize(n_terms, *ps)
      @filters = ps.map {|p| ResiduesExclusions.new(p,n_terms)}
      @ps = ps
    end



    def with(v)
      yield FilterSet.new(@filters.zip(@ps.map {|p| v % p}))
    end



  end


end