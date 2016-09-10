class Refutation < ActiveRecord::Base
  belongs_to :hypothesis
  enum reason:{unknown:0, no_subgoals_generated: 1}
end