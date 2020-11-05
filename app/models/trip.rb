class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  validates_associated :driver, :passenger

  validates :driver_id, presence: true
  validates :passenger_id, presence: true
  validates :date, presence: true
  validates :rating, allow_nil: true,
                     numericality: { only_integer: true,
                                     greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 5}
  validates :cost, numericality: true
  def default
    driver = Driver.find_by(name: "TEST DRIVER")
    driver.available = false
    self[:driver_id] = driver.id
    self[:date] = Time.now.strftime("%d/%m/%Y").to_s
    self[:rating] = nil
    self[:cost] = rand(0...5000.00)
  end
end
