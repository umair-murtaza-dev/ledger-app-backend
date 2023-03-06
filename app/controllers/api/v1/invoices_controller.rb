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
    validates_attachment = Attachment.validates_attachment(params[:attachment])
    return render json: {error_message: validates_attachment}, status: :unprocessable_entity if validates_attachment.is_a?(String)

    image = MiniMagick::Image.new(params[:attachment].tempfile.path)
    image.resize "512x512"
    image.format "jpg" unless ['image/jpeg'].include?(params[:attachment].content_type)
    file_name =  ['image/jpeg'].include?(params[:attachment].content_type) ? params[:attachment].original_filename : params[:attachment].original_filename.gsub("png", "jpg")

    @invoice_attachment = Attachment.find_by(attachment_for: @invoice)
    @invoice_attachment = Attachment.create(company: current_company, attachment_for: @invoice) unless @invoice_attachment.present?
    if @invoice_attachment.attachment.attach io: StringIO.open(image.to_blob), filename: file_name, content_type: image.data["mimeType"], identify: false
      return render json: @invoice_attachment
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
    params.require(:invoice).permit(:amount, :tax_percentage, :discount_percentage, :customer_id)
  end
end
