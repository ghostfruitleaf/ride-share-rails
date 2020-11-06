class DriversController < ApplicationController

  def index
    @drivers = Driver.all
  end

  def show
    driver_id = params[:id].to_i
    @driver = Driver.find_by(id: driver_id)

    if @driver.nil?
      head :not_found
      return
    else
      @trips = @driver.trips
      @trips = @trips.all
    end
  end

  def new
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(driver_params)
    @driver.available = true
    if @driver.save
      redirect_to driver_path(@driver.id)
    else
      render :new
      return
    end
  end

  def edit
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      redirect_to drivers_path
      return
    end
  end

  def update
    @driver = Driver.find_by(id: params[:id].to_i)

    if @driver.nil?
      head :not_found
      return
    elsif @driver.update(driver_params)
      redirect_to drivers_path(@driver)
      return
    else
      render :bad_request
      return
    end
  end

  def destroy
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      head :not_found
      return
    end

    @driver.destroy

    redirect_to drivers_path
    return
  end

  def toggle_online
    driver_id = params[:id]
    @driver = Driver.find_by(id: driver_id)
    if @driver.nil?
      redirect_to drivers_path
      return
    end

    @driver.available = !@driver.available

    if @driver.save
      redirect_to driver_path
      return
    else
      head :not_found
      return
    end
  end

  private

  def driver_params
    return params.require(:driver).permit(:id, :name, :vin, :available)
  end
end
