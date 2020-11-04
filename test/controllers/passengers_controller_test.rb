require "test_helper"

describe PassengersController do
  describe "index" do
    it "responds with success when there are many passengers saved" do
      # Arrange
      # Ensure that there is at least one Driver saved

      # Act

      # Assert

    end

    it "responds with success when there are no passengers saved" do
      # Arrange
      # Ensure that there are zero drivers saved

      # Act

      # Assert

    end
  end

  describe "show" do
    it "responds with success when showing an existing valid passenger" do
      # Arrange
      # Ensure that there is a driver saved

      # Act

      # Assert

    end

    it "responds with 404 with an invalid passenger id" do
      # Arrange
      # Ensure that there is an id that points to no driver

      # Act

      # Assert

    end
  end

  describe "new" do
    it "responds with success" do
    end
  end

  describe "create" do
    it "can create a new passenger with valid information accurately, and redirect" do
      # Arrange
      # Set up the form data

      # Act-Assert
      # Ensure that there is a change of 1 in Driver.count

      # Assert
      # Find the newly created Driver, and check that all its attributes match what was given in the form data
      # Check that the controller redirected the user

    end

    it "does not create a passenger if the form data violates Passenger validations, and responds with a redirect" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Set up the form data so that it violates Driver validations

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Check that the controller redirects

    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid passenger" do
      # Arrange
      # Ensure there is an existing driver saved

      # Act

      # Assert

    end

    it "responds with redirect when getting the edit page for a non-existing passenger" do
      # Arrange
      # Ensure there is an invalid id that points to no driver

      # Act

      # Assert

    end
  end

  describe "update" do
    it "can update an existing passenger with valid information accurately, and redirect" do
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Use the local variable of an existing driver's id to find the driver again, and check that its attributes are updated
      # Check that the controller redirected the user

    end

    it "does not update any passenger if given an invalid id, and responds with a 404" do
      # Arrange
      # Ensure there is an invalid id that points to no driver
      # Set up the form data

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Check that the controller gave back a 404

    end

    it "does not create a passenger if the form data violates Passenger validations, and responds with a redirect" do
      # Note: This will not pass until ActiveRecord Validations lesson
      # Arrange
      # Ensure there is an existing driver saved
      # Assign the existing driver's id to a local variable
      # Set up the form data so that it violates Driver validations

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Check that the controller redirects

    end
  end

  describe "destroy" do
    it "destroys the driver instance in db when driver exists, then redirects" do
      # Arrange
      # Ensure there is an existing driver saved

      # Act-Assert
      # Ensure that there is a change of -1 in Driver.count

      # Assert
      # Check that the controller redirects

    end

    it "does not change the db when the driver does not exist, then responds with 404" do
      # Arrange
      # Ensure there is an invalid id that points to no driver

      # Act-Assert
      # Ensure that there is no change in Driver.count

      # Assert
      # Check that the controller responds or redirects with whatever your group decides

    end
  end
end
