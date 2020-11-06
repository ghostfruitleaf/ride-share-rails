class Driver < ApplicationRecord
  has_many :trips, dependent: :delete_all
  #validation
  validates :name, presence: true
  validates :vin, presence: true
  validates :available, :inclusion => { in: [true, false], message: "must be true or false" }
  def average_rating
    trips = self.trips
    trips = trips.all

    return 0 if trips.empty?

    all_ratings = 0
    num_ratings = 0
    trips.each do |trip|
      if !trip.rating.nil?
        all_ratings += trip.rating
        num_ratings += 1
      end
    end
    return all_ratings.to_f / num_ratings
  end

  # if cost is less than 1.65, drivers keep money
  def total_earnings
    trips = self.trips
    trips = trips.all
    return 0 if trips.empty?
    total = 0
    trips.each do |trip|
      total += trip.cost > 1.65 ? trip.cost * 0.80 - 1.65 : trip.cost * 0.80
    end
    return total
  end

  def offline
    self.available = false
  end

  def online
    self.available = true
  end

  def clear_trips
    Trip.destroy_all(driver_id: self.id)
  end
end
