class Api::V1::ExpensesController < Api::V1::ApplicationController
  before_action :set_expense, only: %i[ show update destroy upload_attachment]

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = current_company.expenses.order(:title)
    @expenses = @expenses.apply_filter(params[:search_query]) if params[:search_query].present?
    @expenses = paginate @expenses, per_page: 20
    render json: {data: @expenses, csv_file_link: ENV['EXPENSES_CSV_EXPORT_PATH']}
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    if @expense
      render json: @expense.attributes
    else
      render json: 'not found', status: :not_found
    end
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params)
    @expense.user_id = current_user.id
    @expense.company_id = current_company.id
    if @expense.save
      render json: @expense.to_json, status: :ok
    else
      render json: @expense.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    if @expense.update(expense_params)
      render json: @expense.to_json, status: :ok
    else
      render json: @expense.errors, status: :unprocessable_entity
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    if @expense.present?
      @expense.destroy
    else
      render json: {error_message: "expense can not be found"}, status: :not_found
    end
  end

  def upload_attachment
    validates_attachment = Attachment.validates_attachment(params[:attachment])
    return render json: {error_message: validates_attachment}, status: :unprocessable_entity if validates_attachment.is_a?(String)

    image = MiniMagick::Image.new(params[:attachment].tempfile.path)
    image.resize "512x512"
    image.format "jpg" unless ['image/jpeg'].include?(params[:attachment].content_type)
    file_name =  ['image/jpeg'].include?(params[:attachment].content_type) ? params[:attachment].original_filename : params[:attachment].original_filename.gsub("png", "jpg")

    @expense_attachment = Attachment.find_by(attachment_for: @expense)
    @expense_attachment = Attachment.create(company: current_company, attachment_for: @expense) unless @expense_attachment.present?
    if @expense_attachment.attachment.attach io: StringIO.open(image.to_blob), filename: file_name, content_type: image.data["mimeType"], identify: false
      return render json: @expense
    end
    render json: @expense, status: :unprocessable_entity
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_expense
    @expense = current_company.expenses.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def expense_params
    params.require(:expense).permit(:vendor_id, :head_of_account_id, :amount, :description, :title, :sales_tax, :witholding_tax)
  end
end
