class Api::V1::StoreLocationsController < Api::V1::ApplicationController
  before_action :set_store_location, only: %i[ show update destroy ]

  # GET /store_locations
  # GET /store_locations.json
  def index
    @store_locations = current_company.store_locations.order(:code)
    @store_locations = @store_locations.apply_filter(params[:search_query]) if params[:search_query].present?
    paginate json: @store_locations, per_page: 20
  end

  # GET /store_locations/1
  # GET /store_locations/1.json
  def show
    if @store_location
      render json: @store_location.to_json, status: :ok
    else
      render json: 'not found', status: :not_found
    end
  end

  # POST /store_locations
  # POST /store_locations.json
  def create
    @store_location = StoreLocation.new(store_location_params)
    @store_location.company_id = current_company.id
    if @store_location.save
      render json: @store_location.to_json, status: :ok
    else
      render json: @store_location.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /store_locations/1
  # PATCH/PUT /store_locations/1.json
  def update
    if @store_location.update(store_location_params)
      render json: @store_location.to_json, status: :ok
    else
      render json: @store_location.errors, status: :unprocessable_entity
    end
  end

  # DELETE /store_locations/1
  # DELETE /store_locations/1.json
  def destroy
    if @store_location.present?
      @store_location.destroy
    else
      render json: {error_message: "store location can not be found"}, status: :not_found
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_store_location
    @store_location = current_company.store_locations.where(id: params[:id])&.first
  end

  # Only allow a list of trusted parameters through.
  def store_location_params
    params.require(:store_location).permit(:code, :manager_id)
  end
end
