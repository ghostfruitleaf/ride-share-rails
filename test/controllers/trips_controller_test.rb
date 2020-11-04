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
      Trip.create(date: Date.today, rating: 5, cost: 3.21)
    end
    it "responds with success when showing an existing valid trip" do
      # Arrange
      id = Trip.find_by(date:"test")[:id]

      # Act
      get trip_path(id)

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

  describe "new" do
    it "responds with success" do
      # Act
      get new_trip_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new trip with valid information accurately, and redirect" do
      # Arrange
      trip_hash = {
          trip: {
              date: "10-11-20",
              rating: 3,
              cost: 2.56
          },
      }

      # Act-Assert
      expect {
        post trips_path, params: trip_hash
      }.must_change "Trip.count", 1

      # Assert
      new_trip = Trip.find_by(date: trip_hash[:trip][:date])
      expect(new_trip.date).must_equal trip_hash[:trip][:date]

      must_respond_with :redirect
      must_redirect_to trip_path(new_trip.id)

    end

    it "does not create a trip if the form data violates Trip validations, and responds with rendering form with errors" do
      # Arrange
      empty_trip = {trip: { date: nil, rating: nil, cost: nil } }

      # Act-Assert
      expect {
        post trips_path, params: empty_trip
      }.wont_change "Trip.count"

      # success indicates rendering of page
      assert_response :success
    end
  end

  describe "edit" do
    before do
      Trip.create(date:"mm-dd-yy", rating: 2, cost: 8.45)
    end
    it "responds with success when getting the edit page for an existing, valid trip" do
      # Arrange
      id = Trip.find_by(date:"mm-dd-yy")[:id]

      # Act
      get edit_trip_path(id)
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
      Trip.create(date:"03-12-20", rating: 1, cost: 3.45)
    end
    let (:edit_trip_data) {
      {
          passenger: {date: "EDITED",
                      rating:0,
                      cost: 0.00}
      }
    }
    it "can update an existing trip with valid information accurately, and redirect" do
      # Arrange
      id = Trip.find_by(date:"mm-dd-yy")[:id]
      # Act-Assert
      expect{
        patch trip_path(id), params: edit_trip_data
      }.wont_change "Trip.count"

      must_redirect_to trip_path(id)

      edited_trip = Trip.find_by(date: edit_trip_data[:trip][:date])
      expect(edited_trip.date).must_equal edit_trip_data[:trip][:date]

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
      id = Trip.find_by(date:"mm-dd-yy")[:id]
      trip = Trip.find_by(id: id)
      empty_trip = {trip: {date:nil, rating:nil, cost:nil}}

      # Act-Assert
      expect {
        patch trip_path(id), params: empty_trip
      }.wont_change "Trip.count"

      # success indicates rendering of page
      assert_response :success
      trip.reload
      expect(trip.date).wont_be_nil
      expect(trip.cost).wont_be_nil
      expect(trip.cost).wont_be_nil
    end
  end

  describe "destroy" do
    it "destroys the trip instance in db when trip exists, then redirects" do
      # Arrange
      delete_me = Trip.new date: "Delete me", rating: 0, cost: 0.00

      delete_me.save
      id = delete_me.id

      # Act
      expect {
        delete trip_path(id)

        # Assert
      }.must_change 'Trip.count', -1

      assert_nil(Trip.find_by(date: delete_me.date))

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
end
