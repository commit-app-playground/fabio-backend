class Account < ApplicationRecord
  has_many :bills

  validates :name, presence: true
end
