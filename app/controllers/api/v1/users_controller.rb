class Api::V1::UsersController < Api::V1::ApplicationController
  before_action :authenticate_company_admin
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  # GET /users.json
  def index
    @users = current_company.users.order("#{params[:order_by]} #{params[:direction]}")
    @users = @users.apply_filter(params[:search_query]) if params[:search_query].present?
    @users = paginate @users, per_page: 20
    render json: {data: @users, csv_file_link: ENV['USERS_CSV_EXPORT_PATH']}, include: [:expenses, :invoices, :role]
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if @user
      render json: @user.to_json, status: :ok
    else
      render json: 'not found', status: :not_found
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.company_id = current_company.id
    if @user.save
      render json: @user.to_json, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      render json: @user.to_json, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user.present?
      @user.destroy
    else
      render json: {error_message: "user can not be found"}, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_company.users.where(id: params[:id])&.first
    render json: {error_message: "user can not be found"}, status: :not_found unless @user.present?
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:firstname, :lastname, :email)
  end
end
