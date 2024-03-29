class Api::V1::ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate_user
  before_action :authenticate_user!
  before_action :set_company

  def set_company
    @current_company = current_user.company
  end

  def current_company
    @current_company
  end

  def authenticate_user
    if request.headers['Authorization'].present?
      authenticate_or_request_with_http_token do |token|
        begin
          jwt_payload = JWT.decode(token, Rails.application.secret_key_base).first

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

  def authenticate_company_admin(options = {})
    head :unauthorized unless current_user.role&.is_company_admin
  end

  def authenticate_admin(options = {})
    head :unauthorized unless current_user.role&.is_admin
  end

  def current_user
    @current_user || User.find_by(id: @current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end
end
