class TripsController < ApplicationController

  def index
    @trips = Trips
  end
end
