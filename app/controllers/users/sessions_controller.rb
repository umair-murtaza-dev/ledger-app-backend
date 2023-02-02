class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # def create
  #   debugger
  #   self.resource = warden.authenticate!(auth_options)
  #   sign_in(resource_name, resource)
  #   render json: { access_token: response.headers['Authorization'] }
  # end
  #
  # def create
  #   super { @token = current_token }
  #       debugger
  # end

  # def current_token
  #   request.env['warden-jwt_auth.token']
  # end

  # def new
  #   super
  # end
  #
  # def create
  #   self.resource = warden.authenticate!(auth_options)
  #   set_flash_message!(:notice, :signed_in)
  #   sign_in(resource_name, resource)
  #   yield resource if block_given?
  #   respond_with resource, location: after_sign_in_path_for(resource)
  # end

  private
  def respond_with(resource, _opts = {})
    render json: { message: 'Logged.' }, status: :ok
  end
  def respond_to_on_destroy
    current_user ? log_out_success : log_out_failure
  end
  def log_out_success
    render json: { message: "Logged out." }, status: :ok
  end
  def log_out_failure
    render json: { message: "Logged out failure."}, status: :unauthorized
  end
end
