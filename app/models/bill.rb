class Bill < ApplicationRecord
  belongs_to :account
  has_many  :bill_payments

  validates :name, :day, presence: true

  broadcasts_to :account,
    target: ->(bill) { "account_#{bill.account.id}_bills" }
end
