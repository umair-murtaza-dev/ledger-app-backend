class Api::V1::VendorsController < Api::V1::ApplicationController
  before_action :set_vendor, only: %i[ show update destroy ]

  # GET /vendors
  # GET /vendors.json
  def index
    @vendors = current_company.vendors
    paginate json: @vendors, per_page: 10
  end

  # GET /vendors/1
  # GET /vendors/1.json
  def show
    if @vendor
      render json: @vendor.to_json, status: :ok
    else
      render json: 'not found', status: :not_found
    end
  end

  # POST /vendors
  # POST /vendors.json
  def create
    @vendor = Vendor.new(vendor_params)
    @vendor.company_id = current_company.id
    if @vendor.save
      render json: @vendor.to_json, status: :ok
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vendors/1
  # PATCH/PUT /vendors/1.json
  def update
    if @vendor.update(vendor_params)
      render json: @vendor.to_json, status: :ok
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /vendors/1
  # DELETE /vendors/1.json
  def destroy
    @vendor&.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_vendor
    @vendor = current_company.vendors.where(id: params[:id])&.first
  end

  # Only allow a list of trusted parameters through.
  def vendor_params
    params.require(:vendor).permit(:company_id, :title, :code, :address)
  end
end
