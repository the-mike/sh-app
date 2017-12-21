class CreateAtms < ActiveRecord::Migration[5.1]
  def change
    create_table :atms do |t|
      t.integer :ones
      t.integer :twos
      t.integer :fives
      t.integer :tens
      t.integer :quarters
      t.integer :fifties
      t.integer :hundreds
      t.integer :withdraw_amount

      t.timestamps
    end
  end
end
