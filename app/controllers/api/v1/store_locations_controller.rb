class Api::V1::StoreLocationsController < Api::V1::ApplicationController
  before_action :set_store_location, only: %i[ show update destroy ]

  # GET /store_locations
  # GET /store_locations.json
  def index
    @store_locations = StoreLocation.all
  end

  # GET /store_locations/1
  # GET /store_locations/1.json
  def show
  end

  # POST /store_locations
  # POST /store_locations.json
  def create
    @store_location = StoreLocation.new(store_location_params)

    if @store_location.save
      render :show, status: :created, location: @store_location
    else
      render json: @store_location.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /store_locations/1
  # PATCH/PUT /store_locations/1.json
  def update
    if @store_location.update(store_location_params)
      render :show, status: :ok, location: @store_location
    else
      render json: @store_location.errors, status: :unprocessable_entity
    end
  end

  # DELETE /store_locations/1
  # DELETE /store_locations/1.json
  def destroy
    @store_location.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store_location
      @store_location = StoreLocation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def store_location_params
      params.require(:store_location).permit(:company_id, :title, :code)

    end
end
