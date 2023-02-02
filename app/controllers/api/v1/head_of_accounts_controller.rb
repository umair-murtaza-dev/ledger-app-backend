class Api::V1::HeadOfAccountsController < Api::V1::ApplicationController
  before_action :set_head_of_account, only: %i[ show update destroy ]

  # GET /head_of_accounts
  # GET /head_of_accounts.json
  def index
    @head_of_accounts = current_company.head_of_accounts
    paginate json: @head_of_accounts
  end

  # GET /vendors/1
  # GET /vendors/1.json
  def show
    if @head_of_account
      render json: @head_of_account.to_json, status: :ok
    else
      render json: 'not found', status: :not_found
    end
  end

  # POST /head_of_accounts
  # POST /head_of_accounts.json
  def create
    @head_of_account = HeadOfAccount.new(head_of_account_params)
    @head_of_account.company_id = current_company.id
    if @head_of_account.save
      render json: @head_of_account.to_json, status: :ok
    else
      render json: @head_of_account.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /head_of_accounts/1
  # PATCH/PUT /head_of_accounts/1.json
  def update
    if @head_of_account.update(head_of_account_params)
      render json: @head_of_account.to_json, status: :ok
    else
      render json: @head_of_account.errors, status: :unprocessable_entity
    end
  end

  # DELETE /head_of_accounts/1
  # DELETE /head_of_accounts/1.json
  def destroy
    @head_of_account.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_head_of_account
      @head_of_account = current_company.head_of_accounts.where(id: params[:id])&.first
    end

    # Only allow a list of trusted parameters through.
    def head_of_account_params
      params.require(:head_of_account).permit(:code, :title)
    end
end
