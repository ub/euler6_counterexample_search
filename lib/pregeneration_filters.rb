module PregenerationFilters
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
    def initialize(n_terms, *ps)
      @filters = ps.map {|p| ResiduesExclusions.new(p,n_terms)}
      @ps = ps
    end

    def set_minuend(v)
      @aggregated_residues =
                @ps.map {|p| v % p}

    end

    def rejects?(u)
      @filters.zip(@aggregated_residues).any? do | f,  ar|
        f.rejects?(ar,u)
      end
    end

  end


end