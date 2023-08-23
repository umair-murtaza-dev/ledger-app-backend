require 'csv'

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def update
    if current_user.update_attributes(user_params)
     render :show
    else
     render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  def export
    @users = User.all

    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=users.csv"
        render "users/export.csv.erb"
      end
      format.html do
        render :index
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password)
  end
end
