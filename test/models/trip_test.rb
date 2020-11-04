require "test_helper"

describe Trip do
  let (:new_trip) {
    Trip.new(date: "mm-dd-yy", rating: 3, cost: 3.11)
  }
  it "can be instantiated" do
    # Your code here
    expect(new_driver.valid?).must_equal true
  end

  it "will have the required fields" do
    # Your code here
    new_trip.save
    trip = Trip.first
    [:date, :rating, :cost].each do |field|

      # Assert
      expect(trip).must_respond_to field
    end
  end

  describe "relationships" do
    # Your tests go here
    it "can have many trips" do
      new_passenger.save
      new_driver = Driver.create(name: "Waldo", vin: "ALWSS52P9NEYLVDE9")
      trip_1 = Trip.create(driver_id: new_driver.id, passenger_id:  new_passenger.id, date: Date.today, rating: 5, cost: 1234)
      trip_2 = Trip.create(driver_id: new_driver.id, passenger_id: new_passenger.id, date: Date.today, rating: 3, cost: 6334)

    # Assert
      expect(new_passenger.trips.count).must_equal 2
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
      expect(new_trip.errors.messages[:date]).must_equal ["can't be blank"]
    end

    it "must have a rating number" do
      # Arrange
      new_trip.rating = nil

      # Assert
      expect(new_trip.valid?).must_equal false
      expect(new_trip.errors.messages).must_include :rating
      expect(new_trip.errors.messages[:rating]).must_equal ["can't be blank"]
    end
  end

  # Tests for methods you create should go here
  describe "custom methods" do
    # Your tests here
  end
end
