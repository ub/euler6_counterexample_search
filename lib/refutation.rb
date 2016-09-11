class Refutation < ActiveRecord::Base
  belongs_to :hypothesis
  enum reason:{unknown:0, no_subgoals_generated: 1,
               divisible_by_p_but_not_by_p_6: 2,
               remainder_not_representable_as_sum_of_6th_power_residues: 3}
end