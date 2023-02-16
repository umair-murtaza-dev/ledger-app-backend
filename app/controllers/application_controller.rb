class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  # protect_from_forgery with: :null_session
  # before_action :underscore_params!

  respond_to :json

  # before_action :cors_preflight_check
  # after_action :cors_set_access_control_headers
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user

# For all responses in this controller, return the CORS access control headers.

# def cors_set_access_control_headers
#     headers['Access-Control-Allow-Origin'] = '*'
#     headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
#     headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With auth_token X-CSRF-Token Authorization, authorization}.join(',')
#     headers['Access-Control-Max-Age'] = "1728000"
# end
#
# def cors_preflight_check
#   if request.method == "OPTIONS"
#     headers['Access-Control-Allow-Origin'] = '*'
#     headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
#     headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With auth_token X-CSRF-Token Authorization authorization}.join(',')
#     headers['Access-Control-Max-Age'] = '1728000'
#     render :text => '', :content_type => 'text/plain'
#   end
# end

private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname])
  end

  def authenticate_user
    if request.headers['Authorization'].present?
      authenticate_or_request_with_http_token do |token|
        begin
          jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first

          @current_user_id = jwt_payload['id']
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
          head :unauthorized
        end
      end
    end
  end

  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end

end
