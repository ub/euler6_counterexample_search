require 'active_record'

class Hypothesis < ActiveRecord::Base
  belongs_to :parent, class_name: 'Hypothesis'
  has_many :subgoals, inverse_of: :parent, class_name: 'Hypothesis', foreign_key: 'parent_id'

  has_one :refutation

  scope :unrefuted, -> {left_outer_joins(:refutation ).where('refutations.id'=> nil)}
  scope :unreduced, -> {left_outer_joins(:subgoals).where( "subgoals_hypotheses.id" => nil)}
  scope :for_terms, ->(n){where(terms_count: n)}
  def value=(v)
    super(v)
  end

  def value
    super.to_i
  end

  def factor
    super.to_i
  end

  alias    x= value=
  alias    x value


  def %(d)
    x % d
  end

  def <= (number)
    value <= number
  end

  def < (number)
    value < number
  end

  def -(s)
    Hypothesis.new(value: x - s, terms_count: terms_count - 1, factor: 1 , parent_id: self.id )
  end

  def div_by!(d)
    self.factor = factor * d
    self.x = x / d
    self
  end

end