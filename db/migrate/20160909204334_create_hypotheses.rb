class CreateHypotheses < ActiveRecord::Migration[5.0]
  def change
    create_table :hypotheses do |t|
      t.string :value, limit: 40
      t.integer :terms_count
      t.string :factor, limit: 40
      t.references :parent, index: true
    end
  end
end
