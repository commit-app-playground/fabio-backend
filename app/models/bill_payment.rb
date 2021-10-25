class BillPayment < ApplicationRecord
  belongs_to :bill

  monetize :amount_cents
  validates :date, :amount, presence: true
end
