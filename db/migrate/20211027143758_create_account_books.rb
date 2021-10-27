class CreateAccountBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :account_books do |t|
      t.string :name, default: :default, null: false

      t.timestamps
    end

    change_table :accounts do |t|
      t.references :account_book, null: false, foreign_key: true
    end
  end
end
