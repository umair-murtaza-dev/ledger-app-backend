class Api::V1::VendorsController < Api::V1::ApplicationController
  before_action :set_vendor, only: %i[ show update destroy ]

  # GET /vendors
  # GET /vendors.json
  def index
    @vendors = current_company.vendors.order("#{params[:order_by]} #{params[:direction]}")
    @vendors = @vendors.apply_filter(params[:search_query]) if params[:search_query].present?
    @vendors = paginate @vendors, per_page: 20
    render json: {data: @vendors, csv_file_link: ENV['VENDORS_CSV_EXPORT_PATH']}, include: [:expenses]
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
    if @vendor.present?
      @vendor.destroy
    else
      render json: {error_message: "vendor can not be found"}, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_vendor
    @vendor = current_company.vendors.where(id: params[:id])&.first
    render json: {error_message: "vendor can not be found"}, status: :not_found unless @vendor.present?
  end

  # Only allow a list of trusted parameters through.
  def vendor_params
    params.require(:vendor).permit(:company_id, :title, :code, :address)
  end
end
