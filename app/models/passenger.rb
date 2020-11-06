class Passenger < ApplicationRecord
  has_many :trips, dependent: :delete_all
  # validation
  validates :name, presence: true
  validates :phone_num, presence: true

  def total_spent
    trips = self.trips
    trips = trips.all
    total = 0
    return trips.empty? ? 0 : trips.inject(0){ |sum, trip| trip.cost + sum }
  end
end
