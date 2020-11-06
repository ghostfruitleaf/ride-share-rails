require "test_helper"

describe TripsController do
  describe "index" do
    it "responds with success when there are many trips saved" do
      # Arrange
      Trip.create date: "test trip", rating: "4", cost: "4.56"
      # Act
      get trips_path
      # Assert
      must_respond_with :success
    end

    it "responds with success when there are no trips saved" do
      # Arrange
      # Ensure that there are zero drivers saved

      # Act
      get trips_path
      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    # Arrange
    before do
      @trip = Trip.create(date: "mm-dd-yy", rating: 5, cost: 3.21)
    end
    it "responds with success when showing an existing valid trip" do
      # # Arrange

      id = @trip.id
      # Act

      get trips_path(@trip.id)

      # Assert
      must_respond_with :success

    end

    it "responds with 404 with an invalid trip id" do
      # Act
      get trip_path(-1)
      # Assert
      must_respond_with :not_found
    end
  end


  describe "create" do

    it "can create a new trip with valid information accurately, and redirect" do
      # Arrange
      passenger = Passenger.create(name: 'hi', phone_num: 'num')
      driver = Driver.create(name: "asjdif", vin: "aajsdofss", available: true)
      trip_hash = {
          trip: {
              passenger_id: passenger.id
        }
      }

      # Act-Assert
      expect {
        post trips_path, params: trip_hash
      }.must_change "Trip.count", 1

      # # Assert
      new_trip = Trip.find_by(passenger_id: trip_hash[:trip][:passenger_id])

      expect(new_trip.rating).must_be_nil
      expect(new_trip.cost>=0.00).must_equal true
      expect(new_trip.cost<50.00).must_equal true

      must_respond_with :redirect
      must_redirect_to trip_path(new_trip.id)


    end

    it "does not create a trip if the form data violates Trip validations, and responds with rendering form with errors" do
      # Arrange
      # empty_trip = {trip: { date: nil, rating: nil, cost: nil } }
      #
      # # Act-Assert
      # expect {
      #   post trips_path, params: empty_trip
      # }.wont_change "Trip.count"
      #
      # # success indicates rendering of page
      # assert_response :success
    end
  end

  describe "edit" do
    before do
      passenger = Passenger.create(name: 'hi', phone_num: 'num')
      driver = Driver.create(name: "asjdif", vin: "aajsdofss", available: true)
      Trip.create!(passenger: passenger, driver: driver, date: Date.today, rating: 2, cost: 8.45)
    end
    it "responds with success when getting the edit page for an existing, valid trip" do
      # Arrange
      id = Trip.find_by(date: Date.today)[:id]
      # id = @trip.id
      # Act
      get edit_trip_path(id)
      # (id)
      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing trip" do
      # Act
      get edit_trip_path(-1)
      # Assert
      must_respond_with :not_found
    end
  end

  describe "update" do
    before do
      passenger = Passenger.create(name: 'hi', phone_num: 'num')
      driver = Driver.create(name: "asjdif", vin: "aajsdofss", available: true)
      Trip.create!(driver: driver, passenger: passenger, date: Date.today, rating: 1, cost: 3.45)
    end
    let (:edit_trip_data) {
      {
          trip: {
              date: Date.today,
                      rating:2,
                      cost: 3.23}
      }
    }
    it "can update an existing trip with valid information accurately, and redirect" do
      # Arrange
      id = Trip.find_by(date: Date.today)[:id]
      # Act-Assert
      expect{
        patch trip_path(id), params: edit_trip_data
      }.wont_change "Trip.count"

      must_redirect_to trip_path(id)

      edited_trip = Trip.find_by(date: edit_trip_data[:trip][:date])
      expect(Date.parse(edited_trip.date)).must_equal edit_trip_data[:trip][:date]

    end

    it "does not update any trip if given an invalid id, and responds with a 404" do
      id = -1
      # Act-Assert
      expect {
        patch trip_path(id), params: edit_trip_data
      }.wont_change "Trip.count"

      must_respond_with :redirect

    end

    it "does not update trip if the form data violates Trip validations, and responds by rendering form with errors listed" do
      # Arrange
      id = Trip.find_by(date: Date.today)[:id]
      trip = Trip.find_by(id: id)
      empty_trip = {trip: {date:nil, rating:nil, cost:nil}}
      bad_trip1 = {trip:{passenger_id: -1, driver_id: -1, date: "blah", rating: 0, cost: -1}}
      bad_trip2 = {trip:{passenger_id: -1, driver_id: -1, date: "blah", rating: 6, cost: -1}}
      # Act-Assert
      expect {
        patch trip_path(id), params: empty_trip
      }.wont_change "Trip.count"

      expect {
        patch trip_path(id), params: bad_trip1
      }.wont_change "Trip.count"

      expect {
        patch trip_path(id), params: bad_trip2
      }.wont_change "Trip.count"

      # success indicates rendering of page
      assert_response :bad_request
      trip.reload
      expect(trip.date).wont_be_nil
      expect(trip.cost).wont_be_nil
      expect(trip.cost).wont_be_nil
    end
  end

  describe "destroy" do
    before do
      passenger = Passenger.create(name: 'hi', phone_num: 'num')
      driver = Driver.create(name: "asjdif", vin: "aajsdofss", available: true)
      Trip.create!(driver: driver, passenger: passenger, date: Date.today, rating: 1, cost: 3.45)
    end

    it "destroys the trip instance in db when trip exists, then redirects" do
      # Arrange
      # trip = Trip.create(date: Date.today, rating: 2)

      id = Trip.find_by(date: Date.today)[:id]
      # id = trip.id
      # Act
      expect {
        delete trip_path(id)
      }.must_change "Trip.count", -1

      deleted_trip = Trip.find_by(date: Date.today, rating: 2)

      # Assert
      expect(deleted_trip).must_be_nil
      must_respond_with :redirect
      must_redirect_to trips_path


    end

    it "does not change the db when the trip does not exist, then responds with 404" do
      # Act
      expect {
        delete trip_path(-1)

        # Assert
      }.wont_change 'Trip.count'

      must_respond_with :not_found
    end
  end

  describe "rate_trip" do
    before do
      passenger = Passenger.create(name: 'hi', phone_num: 'num')
      driver = Driver.create(name: "asjdif", vin: "aajsdofss", available: true)
      Trip.create(passenger: passenger, driver: driver, date: Date.today, rating: 2, cost: 8.45)
    end
    it "responds with success when getting the rate trip for an existing, valid trip" do
      # Arrange
      id = Trip.find_by(date: Date.today)[:id]
      # id = @trip.id
      # Act
      get get_rating_trip_path(id)
      # (id)
      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the rate trip for a non-existing trip" do
      # Act
      get get_rating_trip_path(-1)

      # Act-Assert

      # Assert
      must_respond_with :not_found

    end
  end

  describe "get_rating" do
    before do
      passenger = Passenger.create(name: 'hi', phone_num: 'num')
      driver = Driver.create(name: "asjdif", vin: "aajsdofss", available: true)
      Trip.create!(driver: driver, passenger: passenger, date: Date.today, rating: 1, cost: 3.45)
    end
    let (:edit_trip_data) {
      {
          trip: {
              date: Date.today,
              rating:2,
              cost: 3.23}
      }
    }
    it "can update an existing trip with valid information accurately, and redirect" do
      # Arrange
      id = Trip.find_by(date: Date.today)[:id]
      # Act-Assert
      expect{
        patch trip_path(id), params: edit_trip_data
      }.wont_change "Trip.count"

      must_redirect_to trip_path(id)

      edited_rating = Trip.find_by(date: edit_trip_data[:trip][:date])
      expect(Date.parse(edited_rating.date)).must_equal edit_trip_data[:trip][:date]

    end

    it "does not update any trip if given an invalid id, and responds with a 404" do
      id = -1
      # Act-Assert
      expect {
        patch trip_path(id), params: edit_trip_data
      }.wont_change "Trip.count"

      must_respond_with :redirect

    end
  end

end
