class CreateRefutations < ActiveRecord::Migration[5.0]
  def change
    create_table :refutations do |t|
      t.references :hypothesis, foreign_key: true, index:true
      t.integer :reason
      t.bigint :parameter
    end
  end
end
