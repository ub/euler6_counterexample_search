require 'active_record'

class Hypothesis < ActiveRecord::Base
  belongs_to :parent, class_name: :hypothesis
  def value=(v)
    super(v)
  end

  def value
    super.to_i
  end
  alias    x= value=
  alias    x value
end