class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_company
  respond_to :json
  private
  def respond_with(resource, _opts = {})
    if params[:user][:email].nil?
      render :status => 400,
             :json => {:message => 'User request must contain the user email.'}
      return
    elsif params[:user][:password].nil?
      render :status => 400,
             :json => {:message => 'User request must contain the user password.'}
      return
    end

    if params[:user][:email]
      duplicate_user = User.find_by_email(params[:user][:email])
      unless duplicate_user.nil?
        render :status => 409,
               :json => {:message => 'Duplicate email. A user already exists with that email address.'}
        return
      end
    end

    @user.company_id = @company.id
    if @user.save
      render(status: 200, json: @user.to_json)
    else
      @user = resource
      render :status => 400,
             :json => {:message => @user.errors.full_messages}
    end
  end


  private

  def set_company
    @company = Company.first
    params[:user][:company_id] = @company.id
  end


  def sign_up_params
    params.require(:user).permit(:email, :username, :password)
  end
end
