class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :day, null: false

      t.timestamps
    end
  end
end
