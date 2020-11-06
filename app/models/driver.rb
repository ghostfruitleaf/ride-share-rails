class Driver < ApplicationRecord
  has_many :trips, dependent: :delete_all
  #validation
  validates :name, presence: true
  validates :vin, presence: true

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

  def self.most_available
    # find all available
    available_drivers = Driver.find_all(available: true)
    return -1 if available_drivers.empty?
    # find drivers with no in-progress trips
    no_ip_drivers = []
    available_drivers.each do |driver|
      nil_trip = false
      # check for trips with nil
      driver.trips.each do |trip|
        nil_trip = true if trip.rating.nil?
      end
      # only shovel is !nil_trip
      no_ip_drivers << driver unless nil_trip
    end
    return -1 if available_drivers.empty?

    # find drivers with no trips
    idle_driver = no_ip_drivers.find { |driver| driver.trips.empty? }
    # if result nil, all drivers have at least one trip, must compare for most "stale"
    if idle_driver.nil?
      idle_driver = no_ip_drivers[0]
      driver_last_trip = idle_driver.trips.max_by(&:date)
      no_ip_drivers.each do |driver|
        last_trip = driver.trips.max_by{|trip| Date.parse(trip.date)}
        idle_driver = driver if last_trip.end_time < driver_last_trip.end_time
      end
    end
    return idle_driver
  end
end
