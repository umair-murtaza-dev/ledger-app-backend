class Api::V1::ExpensesController < Api::V1::ApplicationController
  before_action :set_expense, only: %i[ show update destroy ]

  # GET /expenses
  # GET /expenses.json
  def index
    @vendors = current_company.expenses
    paginate json: @vendors
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    if @expense
      render json: @expense.to_json, status: :ok
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
    @expense.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_expense
    @expense = current_company.expenses.where(id: params[:id])&.first
  end

  # Only allow a list of trusted parameters through.
  def expense_params
    params.require(:expense).permit(:vendor_id, :head_of_account_id, :amount, :description, :title, :sales_tax, :witholding_tax)
  end
end
