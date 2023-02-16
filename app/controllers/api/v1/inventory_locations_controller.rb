class Api::V1::InventoryLocationsController < Api::V1::ApplicationController
  before_action :set_inventory_location, only: %i[ show update destroy ]

  # GET /inventory_locations
  # GET /inventory_locations.json
  def index
    @inventory_locations = current_company.inventory_locations
    paginate json: @inventory_locations
  end

  # GET /inventory_locations/1
  # GET /inventory_locations/1.json
  def show
    if @inventory_location
      render json: @inventory_location.to_json, status: :ok
    else
      render json: 'not found', status: :not_found
    end
  end

  # POST /inventory_locations
  # POST /inventory_locations.json
  def create
    @inventory_location = InventoryLocation.new(inventory_location_params)
    @inventory_location.company_id = current_company.id
    if @inventory_location.save
      render json: @inventory_location.to_json, status: :ok
    else
      render json: @inventory_location.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /inventory_locations/1
  # PATCH/PUT /inventory_locations/1.json
  def update
    if @inventory_location.update(inventory_location_params)
      render json: @inventory_location.to_json, status: :ok
    else
      render json: @inventory_location.errors, status: :unprocessable_entity
    end
  end

  # DELETE /inventory_locations/1
  # DELETE /inventory_locations/1.json
  def destroy
    @inventory_location.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_inventory_location
    @inventory_location = current_company.inventory_locations.where(id: params[:id])&.first
  end

    # Only allow a list of trusted parameters through.
  def inventory_location_params
    params.require(:inventory_location).permit(:store_location_id, :inventory_item_id, :quantity)
  end
end
