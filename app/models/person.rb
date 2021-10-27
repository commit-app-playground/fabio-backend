class Person < ApplicationRecord
  has_many :account_book_memberships, dependent: :destroy

  validates :name, presence: true
end
