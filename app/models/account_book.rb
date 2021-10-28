class AccountBook < ApplicationRecord
  has_many :account_book_memberships
  has_many :accounts
  has_many :bills, through: :accounts

  validates :name, presence: true
end
