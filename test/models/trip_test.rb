require "test_helper"

describe Trip do
  # before do
  #
  #   Trip.new(driver: driver, passenger: passenger, date: Date.today, rating: 1, cost: 3.45)
  # end
  let (:new_trip) {
    passenger = Passenger.create(name: 'hi', phone_num: 'num')
    driver = Driver.create(name: "asjdif", vin: "aajsdofss", available: true)
    Trip.new(driver_id: driver.id, passenger_id: passenger.id, date: Date.today, rating: 3, cost: 200)
  }
  it "can be instantiated" do
    # Your code here
    expect(new_trip.valid?).must_equal true
  end

  it "will have the required fields" do
    # Your code here
    new_trip.save
    trip = Trip.first
    [:driver_id, :passenger_id, :date, :rating, :cost].each do |field|

      # Assert
      expect(trip).must_respond_to field
    end
  end

  describe "relationships" do
    # Your tests go here
    it "can have many trips" do
      new_passenger = Passenger.create(name: "Sophie", phone_num:"000 0000")
      new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9", available: true)
      trip_1 = Trip.create(driver_id: new_driver.id, passenger_id:  new_passenger.id, date: Date.today, rating: 5, cost: 1234)
      trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)

    # Assert
      expect(new_passenger.trips.count).must_equal 2
      expect(new_driver.trips.count).must_equal 2
      new_passenger.trips.each do |trip|
      expect(trip).must_be_instance_of Trip
      end
    end
  end

  describe "validations" do
    # Your tests go here
    it "must have a date" do
      # Arrange
      new_trip.date = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :date
      expect(new_trip.errors.messages[:date]).must_equal ["must be valid date.", "can't be blank"]

    end

    it "must have a rating number" do
      # Arrange
      new_trip.rating = 6

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :rating
      expect(new_trip.errors.messages[:rating]).must_equal ["must be less than or equal to 5"]
    end
  end

  # Tests for methods you create should go here
  describe "custom methods" do
    # Your tests here
  end
end
