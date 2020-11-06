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
  def create
    passenger = if params[:passenger_id]
                Passenger.find_by(id: params[:passenger_id])
                elsif params[:trip][:passenger_id]
                Passenger.find_by(id: params[:trip][:passenger_id])
                end
    @trip = passenger.trips.new
    @trip.default
    if @trip.save
      if params[:passenger_id]
        redirect_to passenger_trip_path(id: @trip.id)
      else
        redirect_to trip_path(@trip.id)
      end
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
    trip_id = params[:id]
    @trip = Trip.find_by(id: trip_id)

    if @trip.nil?
      redirect_to trips_path
      return
    end

    if @trip.update(trip_params)
      redirect_to trip_path(@trip.id)
      return
    else
      render :edit, status: :bad_request
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
      if params[:passenger_id]
        redirect_to passenger_path(params[:passenger_id])
      elsif params[:driver_id]
        redirect_to driver_path(params[:driver_id])
      else
        redirect_to trips_path
      end
    else
      head :not_found
      return
    end
  end

  def rate_trip
    trip_id = params[:id]
    @trip = Trip.find_by(id: trip_id)

    if @trip.nil?
      head :not_found
      return
    end
  end

  def get_rating
    trip_id = params[:id]
    @trip = Trip.find_by(id: trip_id)

    if @trip.nil?
      redirect_to trips_path
      return
    end

    if @trip.update(trip_params)
      redirect_to trip_path(@trip.id)
      return
    else
      render :rate_trip
      return
    end
  end

  private

  def trip_params
    return params.require(:trip).permit(:driver_id, :passenger_id, :date, :rating, :cost)
  end
end
