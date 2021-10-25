class Account < ApplicationRecord
  has_many :bills, dependent: :destroy

  validates :name, presence: true
end
