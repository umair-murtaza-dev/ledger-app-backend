class Api::V1::AccountsController < Api::V1::ApplicationController
  before_action :set_account, only: %i[ show update destroy upload_attachment]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = current_company.accounts.order("#{params[:order_by]} #{params[:direction]}")
    @accounts = @accounts.apply_filter(params[:search_query]) if params[:search_query].present?
    @accounts = paginate @accounts, per_page: 20
    render json: {data: @accounts, csv_file_link: ENV['ACCOUNTS_CSV_EXPORT_PATH']}
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    if @account
      render json: @account.attributes
    else
      render json: 'not found', status: :not_found
    end
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)
    @account.user_id = current_user.id
    @account.company_id = current_company.id
    if @account.save
      render json: @account.to_json, status: :ok
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    if @account.update(account_params)
      render json: @account.to_json, status: :ok
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    if @account.present?
      @account.destroy
    else
      render json: {error_message: "account can not be found"}, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = current_company.accounts.find_by(id: params[:id])
    render json: {error_message: "account can not be found"}, status: :not_found unless @account.present?
  end

  # Only allow a list of trusted parameters through.
  def account_params
    params.require(:account).permit(:title, :bank_name, :account_no, :iban, :currency, :balance, :account_type)
  end
end
