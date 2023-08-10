class Api::V1::CustomersController < Api::V1::ApplicationController
  before_action :set_customer, only: %i[ show update destroy ]

  # GET /customers
  # GET /customers.json
  def index
    @customers = current_company.customers.order(:firstname, :lastname)
    @customers = @customers.apply_filter(params[:search_query]) if params[:search_query].present?
    paginate json: @customers, per_page: 20
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    if @customer
      render json: @customer.to_json, status: :ok
    else
      render json: 'not found', status: :not_found
    end
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)
    @customer.company_id = current_company.id
    if @customer.save
      render json: @customer.to_json, status: :ok
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    if @customer.update(customer_params)
      render json: @customer.to_json, status: :ok
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    if @customer.present?
      @customer.destroy
    else
      render json: {error_message: "customer can not be found"}, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = current_company.customers.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(:firstname, :lastname, :currency, :phone, :address)
    end
end
