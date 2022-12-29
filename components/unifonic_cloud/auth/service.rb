class UnifonicCloud::Auth::Service
  def user(token:)
    return if token.blank? || token.to_s == 'null'
    response = UnifonicCloud::Auth::Transciever.new(token: token).me
    return if response.last != 200
    create_dto(response.first)
  end

  def top_bar(token:)
    return if token.blank? || token.to_s == 'null'
    response = UnifonicCloud::Auth::Transciever.new(token: token, response_json: false).top_bar
    return if response.last != 200
    response.first
  end

  def get_access_token(code:, redirect_uri:)
    params = {
      client_id: ENV['ledger_unifonic_cloud_client_id'],
      client_secret: ENV['ledger_unifonic_cloud_client_secret'],
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: redirect_uri
    }
    UnifonicCloud::Auth::Transciever.new.token(params: params)
  end

  def settings
    {
      redirect_uri: ENV['ledger_frontend_home_url'],
      logout_url: ENV['ledger_unifonic_cloud_logout_url'],
      me_url: ENV['ledger_unifonic_cloud_me_url'],
      auth_url: ENV['ledger_unifonic_cloud_auth_url'].to_s % { client_id: ENV['ledger_unifonic_cloud_client_id'], redirect_uri: ENV['ledger_frontend_check_login'] }
    }
  end

  def get_dto(user)
    create_dto(user)
  end
  private

  def create_dto(response_data)
    return if response_data.blank? || response_data['user'].blank?
    user = response_data['user']
    UnifonicCloud::Auth::UserDto.new(
      id: user['id'],
      email: user['email'],
      first_name: user['firstName'],
      last_name: user['lastName'],
      name: [user['firstName'], user['lastName']].select(&:present?).join(' '),
      phone: user['phone'],
      roles: user['roles'],
      permissions: user['permissions']&.with_indifferent_access,
      system_settings: response_data['systemSettings']&.with_indifferent_access,
      account: account_dto(user['account']),
      timezone: user['timezone'],
      is_admin_level: user['isAdminLevel'],
      default_currency: user['defaultCurrency']
    )
  end

  def account_dto(account_data)
    return if account_data.blank?
    UnifonicCloud::Auth::AccountDto.new(
      id: account_data['id'],
      provisioning_id: account_data['provisioningId'],
      charging_id: account_data['chargingId'],
      crm_id: account_data['crmId'],
      name: account_data['name'],
      balance: account_data['balance'],
      country: account_data['country'],
      account_manager_name: account_data['accountManagerName'],
      account_manager_email: account_data['accountManagerEmail'],
      type: account_data['type'],
      category: account_data['category'],
      two_factory_authentication_enabled: account_data['twoFactorAuthenticationEnabled']
    )
  end
end
