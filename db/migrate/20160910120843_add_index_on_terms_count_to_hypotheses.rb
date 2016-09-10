class AddIndexOnTermsCountToHypotheses < ActiveRecord::Migration[5.0]
  def change
    add_index :hypotheses, :terms_count
  end
end
