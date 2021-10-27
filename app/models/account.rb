class Account < ApplicationRecord
  belongs_to :account_book
  has_many :bills, dependent: :destroy

  validates :name, presence: true

  broadcasts_to :account_book
end
