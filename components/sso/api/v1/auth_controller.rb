class Sso::Api::V1::AuthController < Sso::Api::V1::ApplicationController
  skip_before_action :authenticate!

  def index
    response = UnifonicCloud::Auth::Service.new.get_access_token(code: params[:code], redirect_uri: params[:redirect_uri])
    render json: response.first, status: response.last
  end

  def redirect_to_login
    render json: { auth_url: auth_url }, status: :ok
  end
end
