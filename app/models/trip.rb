class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  validates_associated :driver, :passenger
  validate :valid_date

  validates :driver_id, presence: true
  validates :passenger_id, presence: true
  validates :date, presence: true
  validates :rating, allow_nil: true,
                     numericality: { only_integer: true,
                                     greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 5}
  validates :cost, numericality: { greater_than_or_equal_to: 0 }

  def default
    driver = Driver.where(available: true).first
    driver.available = false
    self.driver_id = driver.id
    self.date = Date.today.to_formatted_s(:db)
    self.rating = nil
    self.cost = rand(0...50.00)
  end

  def valid_date
    begin
      Date.parse(self.date).to_formatted_s(:db)
    rescue
      self.errors[:date] << 'must be valid date.'
    end
  end
end
