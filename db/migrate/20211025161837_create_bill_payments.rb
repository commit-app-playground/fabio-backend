class CreateBillPayments < ActiveRecord::Migration[7.0]
  def change
    create_table :bill_payments do |t|
      t.references :bill, null: false, foreign_key: true
      t.date :date, null: false
      t.monetize :amount

      t.timestamps
    end
  end
end
