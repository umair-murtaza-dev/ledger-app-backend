class Api::V1::InventoryItemsController < Api::V1::ApplicationController
  before_action :set_inventory_item, only: %i[ show update destroy ]

  # GET /inventory_items
  # GET /inventory_items.json
  def index
    @inventory_items = InventoryItem.all
  end

  # GET /inventory_items/1
  # GET /inventory_items/1.json
  def show
  end

  # POST /inventory_items
  # POST /inventory_items.json
  def create
    @inventory_item = InventoryItem.new(inventory_item_params)

    if @inventory_item.save
      render :show, status: :created, location: @inventory_item
    else
      render json: @inventory_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /inventory_items/1
  # PATCH/PUT /inventory_items/1.json
  def update
    if @inventory_item.update(inventory_item_params)
      render :show, status: :ok, location: @inventory_item
    else
      render json: @inventory_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /inventory_items/1
  # DELETE /inventory_items/1.json
  def destroy
    @inventory_item.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inventory_item
      @inventory_item = InventoryItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def inventory_item_params
      params.require(:inventory_item).permit(:company_id, :code, :title, :description)
    end
end
