class Passenger < ApplicationRecord
  has_many :trips
  # validation
  validates :name, presence: true
  validates :phone_num, presence: true
end
