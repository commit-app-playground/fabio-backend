class CreateAccountBookMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :account_book_memberships do |t|
      t.references :account_book, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.string :role, null: false

      t.timestamps
    end
  end
end
