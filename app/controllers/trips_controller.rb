class TripsController < ApplicationController

  def index
    @trips = Trip.all
  end

  def show
    @trip = Trip.find_by(id: params[:id])
    if @trip.nil?
      head :not_found
      return
    end
  end

  # CREATE
  def new
    @trip = Passenger.new
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      redirect_to trip_path(@trip.id)
      return
    else
      render :new
      return
    end
  end

  # UPDATE
  def edit
    @trip = Trip.find_by(id: params[:id])
    if @trip.nil?
      head :not_found
      return
    end
  end

  def update
    passenger_id = params[:id]
    @passenger = Passenger.find_by(id: passenger_id)

    if @trip.nil?
      redirect_to trips_path
      return
    end

    if @trip.update(trip_params)
      redirect_to trip_path(@trip.id)
      return
    else
      render :edit
      return
    end
  end

  # DESTROY
  def destroy
    trip_id = params[:id]
    @trip = Trip.find_by(id: trip_id)
    # NOTE: confirmation page is handled by index and show pages as a dialog box.
    if @trip
      @trip.destroy
      redirect_to trips_path
    else
      head :not_found
      return
    end
  end

  private

  def trip_params
    return params.require(:trip).permit(:driver_id,:passenger_id,:date,:rating,:cost)
  end
end
