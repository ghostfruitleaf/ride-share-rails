class Driver < ApplicationRecord
  has_many :trips
  #validation
  validates :name, presence: true
  validates :vin, presence: true
end
