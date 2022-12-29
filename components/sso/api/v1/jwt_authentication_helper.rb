module Sso::Api::V1::JwtAuthenticationHelper
  def authenticate!
    unless authenticate_sso
      return render json: { message: "invalid or expired token"}, status: :unauthorized
    end
  end

  def authenticate_sso
    token = get_token
    return render json: { message: "empty token"}, status: :unauthorized if token.blank?
    payload = decode_token(token)
    return false if payload.blank?
    return  false if payload.length != 2
    payload = payload.first
    return false if payload["exp"].blank? || payload["user"].blank?
    return false if DateTime.now > Time.at(payload["exp"]).to_datetime
    @current_user = UnifonicCloud::Auth::Service.new.get_dto(JSON.parse(Zlib::Inflate.inflate(Base64.decode64(payload['user']))))
    return false if @current_user.blank?
    @current_account = @current_user.account
    return true
  end

  def current_user
    @current_user
  end

  def current_account
    @current_account
  end

  def jwt_secret_key
    ENV['ledger_jwt_secret_key'] || "secretKey"
  end

  def lifetime
    ENV['ledger_jwt_lifetime'] || 3600
  end

  def get_token
    request.headers['Authorization'].present? ? request.headers['Authorization'].to_s.split('Bearer ').last : params[:auth_token]
  end

  def decode_token(token)
    Common::Helpers::Authenticator.new(secret: jwt_secret_key).authenticate(token: token)
  end

  def can?(app, module_name, actions, check_account=true)
    return false if check_account && !current_account && !current_user.roles.include?("ADMIN")
    return true if check_account && ENV["ledger_disable_permission_check_all"] == "true"
    return false unless current_user
    permissions = current_user.permissions
    return false if permissions.blank?
    return false if permissions[app].blank?
    return false if permissions[app][module_name].blank?
    return false if (Array(permissions[app][module_name]) & Array(actions)).blank?
    return true
  end
  def current_user
    @current_user
  end

  def current_account
    @current_account
  end

  def forbidden
    render json: {}, status: :forbidden
  end
end
