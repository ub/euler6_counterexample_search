class CreateConfirmations < ActiveRecord::Migration[5.0]
  def change
    create_table :confirmations do |t|
      t.references :hypothesis, foreign_key: true
      t.bigint :root
    end
  end
end
