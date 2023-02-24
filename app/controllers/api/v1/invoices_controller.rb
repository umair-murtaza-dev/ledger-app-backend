class Api::V1::InvoicesController < Api::V1::ApplicationController
  before_action :set_invoice, only: %i[ show update destroy upload_attachment]

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = current_company.invoices
    @invoices = paginate @invoices, per_page: 10
    render json: @invoices
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    if @invoice
      render json: @invoice.attributes
    else
      render json: 'not found', status: :not_found
    end
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.user_id = current_user.id
    @invoice.company_id = current_company.id
    if @invoice.save
      render json: @invoice.to_json, status: :ok
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    if @invoice.update(invoice_params)
      render json: @invoice.to_json, status: :ok
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    if @invoice.present?
      @invoice.destroy
    else
      render json: {error_message: "invoice can not be found"}, status: :not_found
    end
  end

  def upload_attachment
    return render json: {error_message: "file not attached"}, status: :unprocessable_entity unless params[:attachment].present?
    return render json: {error_message: "size needs to be less than 5MB"}, status: :unprocessable_entity if params[:attachment].size > 5.megabytes
    return render json: {error_message: "file format invalid"}, status: :unprocessable_entity unless ['image/jpeg', 'image/jpg', 'image/png'].include?(params[:attachment].content_type)

    image = MiniMagick::Image.new(params[:attachment].tempfile.path)
    image.resize "512x512"
    image.format "jpg" unless ['image/jpeg'].include?(params[:attachment].content_type)
    file_name =  ['image/jpeg'].include?(params[:attachment].content_type) ? params[:attachment].original_filename : params[:attachment].original_filename.gsub("png", "jpg")

    if @invoice.attachment.attach io: StringIO.open(image.to_blob), filename: file_name, content_type: image.data["mimeType"], identify: false
      return render json: @invoice.attributes
    end
    render json: @invoice, status: :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = current_company.invoices.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def invoice_params
    params.require(:invoice).permit(:from_name, :from_address, :from_phone,:to_name, :to_address, :to_phone, :currency, :amount, :tax_percentage, :discount_percentage)
  end
end
