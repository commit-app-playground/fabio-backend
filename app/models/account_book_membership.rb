class AccountBookMembership < ApplicationRecord
  belongs_to :account_book
  belongs_to :person

  enum roles: { owner: :owner, guest: :guest }
  validates :role, presence: true
end
