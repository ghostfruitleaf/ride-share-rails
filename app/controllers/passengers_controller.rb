class PassengersController < ApplicationController

  def index
    @passengers = Passenger
  end


end
