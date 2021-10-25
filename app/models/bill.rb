class Bill < ApplicationRecord
  belongs_to :account
  has_many :bill_payments

  validates :name, :day, presence: true
end
