require "test_helper"

describe PassengersController do
  describe "index" do
    it "responds with success when there are many passengers saved" do
      # Arrange
      Passenger.create name: "test passenger", phone_num: "1234567890"
      # Act
      get passengers_path
      # Assert
      must_respond_with :success
    end

    it "responds with success when there are no passengers saved" do
      # Arrange
      # Ensure that there are zero drivers saved

      # Act
      get passengers_path
      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    # Arrange
    before do
      Passenger.create(name:"test", phone_num: "000 000 0000")
    end
    it "responds with success when showing an existing valid passenger" do
      # Arrange
      id = Passenger.find_by(name:"test")[:id]

      # Act
      get passenger_path(id)

      # Assert
      must_respond_with :success

    end

    it "responds with 404 with an invalid passenger id" do
      # Act
      get passenger_path(-1)
      # Assert
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "responds with success" do
      # Act
      get new_passenger_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new passenger with valid information accurately, and redirect" do
      # Arrange
      passenger_hash = {
        passenger: {
          name: "new me",
          phone_num: "new phone",
        },
      }

      # Act-Assert
      expect {
        post passengers_path, params: passenger_hash
      }.must_change "Passenger.count", 1

      # Assert
      new_passenger = Passenger.find_by(name: passenger_hash[:passenger][:name])
      expect(new_passenger.phone_num).must_equal passenger_hash[:passenger][:phone_num]

      must_respond_with :redirect
      must_redirect_to passenger_path(new_passenger.id)

    end

    it "does not create a passenger if the form data violates Passenger validations, and responds with rendering form with errors" do
      # Arrange
      empty_passenger = {passenger: {name:nil, description:nil}}

      # Act-Assert
      expect {
        post passengers_path, params: empty_passenger
      }.wont_change "Passenger.count"

      # success indicates rendering of page
      assert_response :success
    end
  end

  describe "edit" do
    before do
      Passenger.create(name:"test", phone_num: "000 000 0000")
    end
    it "responds with success when getting the edit page for an existing, valid passenger" do
      # Arrange
      id = Passenger.find_by(name:"test")[:id]

      # Act
      get edit_passenger_path(id)
      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing passenger" do
      # Act
      get edit_passenger_path(-1)
      # Assert
      must_respond_with :not_found
    end
  end

  describe "update" do
    before do
      Passenger.create(name:"test", phone_num: "000 000 0000")
    end
    let (:edit_passenger_data) {
      {
        passenger: {name: "EDITED",
               phone_num:"111 111 1111"}
      }
    }
    it "can update an existing passenger with valid information accurately, and redirect" do
      # Arrange
      id = Passenger.find_by(name:"test")[:id]
      # Act-Assert
      expect{
        patch passenger_path(id), params: edit_passenger_data
      }.wont_change "Passenger.count"

      must_redirect_to passenger_path(id)

      edited_passenger = Passenger.find_by(name: edit_passenger_data[:passenger][:name])
      expect(edited_passenger.phone_num).must_equal edit_passenger_data[:passenger][:phone_num]

    end

    it "does not update any passenger if given an invalid id, and responds with a 404" do
      id = -1
      # Act-Assert
      expect {
        patch passenger_path(id), params: edit_passenger_data
      }.wont_change "Passenger.count"

      must_respond_with :redirect

    end

    it "does not update passenger if the form data violates Passenger validations, and responds by rendering form with errors listed" do
      # Arrange
      id = Passenger.find_by(name:"test")[:id]
      passenger = Passenger.find_by(id: id)
      empty_passenger = {passenger: {name:nil, phone_num:nil}}

      # Act-Assert
      expect {
        patch passenger_path(id), params: empty_passenger
      }.wont_change "Passenger.count"

      # success indicates rendering of page
      assert_response :success
      passenger.reload
      expect(passenger.name).wont_be_nil
      expect(passenger.phone_num).wont_be_nil
    end
  end

  describe "destroy" do
    it "destroys the passenger instance in db when passenger exists, then redirects" do
      # Arrange
      delete_me = Passenger.new name: "Delete me", phone_num: "Delete me"

      delete_me.save
      id = delete_me.id

      # Act
      expect {
        delete passenger_path(id)

        # Assert
      }.must_change 'Passenger.count', -1

      assert_nil(Passenger.find_by(name: delete_me.name))

      must_respond_with :redirect
      must_redirect_to passengers_path


    end

    it "deletes any trips associated with a deleted passenger" do
      # Arrange
      driver = Driver.create(name: "Marta Mora", vin: "SU9PYDRK6214WL15M", available: true)
      # driver.save
      passenger = Passenger.create(name: "Shiba", phone_num: "000 000 0000")
      passenger.save
      trip = Trip.create(driver_id: driver.id, passenger_id: passenger.id, date: Date.today, rating: 5, cost: 10.00)
      id = passenger.id
      trip_id = trip.id
      # Act
      expect {
        delete passenger_path(id)
      }.must_change "Passenger.count", -1

      deleted_passenger = Passenger.find_by(name: "Shiba")

      # Assert
      expect(deleted_passenger).must_be_nil
      must_respond_with :redirect
      must_redirect_to passengers_path
      expect(Trip.find_by(id:trip_id)).must_be_nil
    end

    it "does not change the db when the passenger does not exist, then responds with 404" do
      # Act
      expect {
        delete passenger_path(-1)

        # Assert
      }.wont_change 'Passenger.count'

      must_respond_with :not_found
    end
  end
end
