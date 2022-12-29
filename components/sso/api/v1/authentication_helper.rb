module Sso::Api::V1::AuthenticationHelper
  def authenticate!
    return if skip_authentication?
    unless authenticate_sso
      return render json: { auth_url: auth_url}, status: :unauthorized
    end
  end

  def authenticate_sso
    @is_mocked = false
    token = get_token
    response = authenticate_uc_sso(token) unless is_mocking_token?(token)
    response = authenticate_mock_sso(token) unless response
    response
  end

  def authenticate_uc_sso(token)
    return if token.blank?
    @current_user = UnifonicCloud::Auth::Service.new.user(token: token)
    return false if @current_user.blank?
    @current_account = @current_user.account
    return true
  end

  def authenticate_mock_sso(token)
    return false unless sso_mocking?
    @current_user = Mocking::Service.new(token == 'admin').current_user
    @current_account = @current_user.account
    @is_mocked = true
    true
  end

  def is_mocked?
    @is_mocked
  end

  def current_user
    @current_user
  end

  def current_account
    @current_account
  end

  def auth_url
    data = { client_id: ENV['ledger_unifonic_cloud_client_id'], redirect_uri: redirect_uri }
    ENV['ledger_unifonic_cloud_auth_url'].to_s % data
  end

  def redirect_uri
    ENV['ledger_frontend_check_login']
  end

  def get_token
    request.headers['Authorization'].present? ? request.headers['Authorization'].to_s.split('Bearer ').last : params[:auth_token]
  end

  def skip_authentication?
    false
  end

  def skip_authorization?
    false
  end

  def can?(app, module_name, actions, check_account=true)
    return true if skip_authorization?
    return false if check_account && !current_account && !current_user.roles.include?("ADMIN")
    return true if check_account  && ENV["ledger_disable_permission_check_all"] == "true"
    return false unless current_user
    permissions = current_user.permissions
    return false if permissions.blank?
    return false if permissions[app].blank?
    return false if permissions[app][module_name].blank?
    return false if (Array(permissions[app][module_name]) & Array(actions)).blank?
    return true
  end

  def forbidden
    render json: {}, status: :forbidden
  end

  def get_sender_sids(without_presenter=false, account_id: nil)
    return [] unless can?('CC', 'SENDER_NAME', ['SEE_OWN', 'SEE_ALL'])
    sender_ids = Nextgen::SenderIds::SenderIdService.new(account_id: current_account ? current_account.id : account_id).all_approved
    generic_sender_ids = GenericSenderIds::GenericSenderIdService.new.filter(criteria: { activated: true }, per_page: nil)
    sender_ids = (generic_sender_ids | sender_ids).uniq{ |a| a.sender_id }
    return sender_ids if without_presenter
    sender_ids.map{|sender_id| Sso::Presenter::SenderId.new(dto: sender_id).present }
  end

  def get_app_sids(account_id: nil)
    return [] unless can?('CC', 'APPS_ID', ['SEE_OWN', 'SEE_ALL'])
    app_sids = Nextgen::AppSids::AppSidService.new(account_id: current_account ? current_account.id : account_id).all_approved
    app_sids.map{|app_sid| Sso::Presenter::AppSid.new(dto: app_sid).present }
  end

  def sso_mocking?
    !!(Rails.application.credentials&.sso_mocking)
  end

  def is_mocking_token?(token)
    token.blank? || token.in?(['normal', 'admin'])
  end
end
