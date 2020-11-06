require "test_helper"

describe DriversController do
  # Note: If any of these tests have names that conflict with either the requirements or your team's decisions, feel empowered to change the test names. For example, if a given test name says "responds with 404" but your team's decision is to respond with redirect, please change the test name.

  describe "index" do
    it "responds with success when there are many drivers saved" do
      # Arrange
      # Ensure that there is at least one Driver saved
      @driver_1 = Driver.create(name: "Juan Lopez", vin: "TAMX2B609RPZY1XHT", available: true)
      @driver_2 = Driver.create(name: "Pauline Chane", vin: "W092FDPH6FNNK102M", available: true)
      @driver_3 = Driver.create(name: "John Smith", vin: "J811TNPS4FYZF4VGU", available: true)

      # Act
      get drivers_path
      # Assert
      must_respond_with :success
    end

    it "responds with success when there are no drivers saved" do
      # Arrange
      # Ensure that there are zero drivers saved

      # Act
      get drivers_path
      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    before do
      @driver_1 = Driver.create(name: "Juan Lopez", vin: "TAMX2B609RPZY1XHT", available: true)
      @driver_2 = Driver.create(name: "Pauline Chane", vin: "W092FDPH6FNNK102M", available: true)
      @driver_3 = Driver.create(name: "John Smith", vin: "J811TNPS4FYZF4VGU", available: true)

    end

    it "responds with success when showing an existing valid driver" do
      # Arrange
      # Ensure that there is a driver saved

      # Act
      get driver_path(@driver_1.id)

      # Assert
      must_respond_with :success


    end

    it "responds with 404 with an invalid driver id" do
      # Arrange
      # Ensure that there is an id that points to no driver

      # Act
      get driver_path(-1)
      # Assert
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "responds with success" do
      get new_driver_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new driver with valid information accurately, and redirect" do
      # Arrange
      # Set up the form data
      driver_hash = {
          driver: {
              name: "Marta Mora",
              vin: "SU9PYDRK6214WL15M"
          },
      }
      # Act-Assert
      # Ensure that there is a change of 1 in Driver.count
      expect{
        post drivers_path, params: driver_hash
      }.must_change "Driver.count", 1

      new_driver = Driver.find_by(name: driver_hash[:driver][:name])

      expect(new_driver.vin).must_equal driver_hash[:driver][:vin]
      expect(new_driver.available).must_equal true

      must_respond_with :redirect
      must_redirect_to driver_path(new_driver.id)


    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Set up the form data so that it violates Driver validations
      empty_driver = {driver: {name: nil, vin: nil}}

      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect{
        post drivers_path, params: empty_driver
      }.wont_change "Driver.count"
      # Assert
      # Check that the controller redirects
      assert_response :success

    end
  end
  
  describe "edit" do
    before do
      @driver_1 = Driver.create(name: "Juan Lopez", vin: "TAMX2B609RPZY1XHT", available: true)
      @driver_2 = Driver.create(name: "Pauline Chane", vin: "W092FDPH6FNNK102M", available: true)
      @driver_3 = Driver.create(name: "John Smith", vin: "J811TNPS4FYZF4VGU", available: true)
    end
    it "responds with success when getting the edit page for an existing, valid driver" do

      # Act

      get edit_driver_path(@driver_1)

      # Assert
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing driver" do

      # Act
      get edit_driver_path(-1)
      # Assert
      must_respond_with :redirect
    end
  end

  describe "update" do
    before do
      Driver.create(name: "Driver Test", vin: "1C9511EE4YR35640C" , available: true)
    end
    let (:new_driver_hash) {
      {driver:
           {name: "Mary Jane",
            vin: "RF4NN09F9JH8738HF",
            available: false}
      }
    }
    it "can update an existing driver with valid information accurately, and redirect" do
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data
      id = Driver.first.id


      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect {
        patch driver_path(id), params: new_driver_hash
      }.wont_change 'Driver.count'

      # Assert
      # Use the local variable of an existing driver's id to find the driver again, and check that its attributes are updated
      # Check that the controller redirected the user
      must_respond_with :redirect

      updated_driver = Driver.find_by(id: id)
      expect(updated_driver.name).must_equal new_driver_hash[:driver][:name]
      expect(updated_driver.vin).must_equal new_driver_hash[:driver][:vin]
      expect(updated_driver.available).must_equal false

    end

    it "does not update any driver if given an invalid id, and responds with a 404" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      # Set up the form data

      # Act-Assert
      expect {
        patch driver_path(-1), params: new_driver_hash
      }.wont_change 'Driver.count'

      must_respond_with :not_found

    end

    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Set up the form data so that it violates Driver validations
      empty_driver = {driver: {name: nil, vin: nil}}

      # Act-Assert
      # Ensure that there is no change in Driver.count
      expect{
        post drivers_path, params: empty_driver
      }.wont_change "Driver.count"
      # Assert
      # Check that the controller redirects
      assert_response :success

    end
  end

  describe "destroy" do
    it "destroys the driver instance in db when driver exists, then redirects" do
      # Arrange
      driver = Driver.create(name: "Marta Mora", vin: "SU9PYDRK6214WL15M", available: true)
      id = driver.id

      # Act
      expect {
        delete driver_path(id)
      }.must_change "Driver.count", -1

      deleted_driver = Driver.find_by(name: "Marta Mora")

      # Assert
      expect(deleted_driver).must_be_nil
      must_respond_with :redirect
      must_redirect_to drivers_path

    end

    it "deletes any trips associated with a deleted driver" do
      # Arrange
      driver = Driver.create(name: "Marta Mora", vin: "SU9PYDRK6214WL15M", available: true)
      driver.save
      passenger = Passenger.create(name: "Shiba", phone_num: "000 000 0000")
      trip = Trip.create(driver_id: driver.id, passenger_id: passenger.id, date: Date.today, rating: 5, cost: 10.00)
      id = driver.id
      trip_id = trip.id
      # Act
      expect {
        delete driver_path(id)
      }.must_change "Driver.count", -1

      deleted_driver = Driver.find_by(name: "Marta Mora")

      # Assert
      expect(deleted_driver).must_be_nil
      must_respond_with :redirect
      must_redirect_to drivers_path
      expect(Trip.find_by(id:trip_id)).must_be_nil
    end

    it "does not change the db when the driver does not exist, then responds with " do
      # Arrange
      # Ensure there is an invalid id that points to no driver

      # Act-Assert
      expect {
        delete driver_path(-1)
      }.wont_change "Driver.count"

      # Assert
      must_respond_with :not_found

    end
  end

  describe "toggle_online" do
    # Arrange
    before do
      @driver_1 = Driver.create(name: "Juan Lopez", vin: "TAMX2B609RPZY1XHT", available: true)
    end
    # Note:  If there was a way to fail to save the changes to a task, that would be a great
    #        thing to test - used validation and added a test for "create" as well!
    it "can toggle a driver between on and offline" do
      # Arrange
      id = @driver_1.id
      # Act-Assert
      # incomplete -> incomplete
      expect{
        patch toggle_online_driver_path(id)
      }.wont_change "Driver.count"

      must_redirect_to driver_path(id)

      toggled_driver = Driver.find_by(id: id)
      expect(toggled_driver.available).must_equal false


      expect{
        patch toggle_online_driver_path(id)
      }.wont_change "Driver.count"

      must_redirect_to :driver

      toggled_driver = Driver.find_by(id: id)
      expect(toggled_driver.available).must_equal true

    end

    it "will redirect to the drivers page if given an invalid id" do
      id = -1
      # Act-Assert
      expect {
        patch toggle_online_driver_path(id)
      }.wont_change "Driver.count"

      must_redirect_to :drivers
    end
  end
end
