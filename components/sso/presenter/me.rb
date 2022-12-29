class Sso::Presenter::Me
  def initialize(dto:)
    @user = dto
  end

  def present
    return {} unless @user
    {
      id: @user.id,
      email: @user.email,
      first_name: @user.first_name,
      last_name: @user.last_name,
      phone: @user.phone,
      roles: @user.roles,
      permissions: @user.permissions,
      system_settings: @user.system_settings,
      timezone: @user.timezone,
      is_admin_level: @user.is_admin_level,
      account: @user.account,
      currency: @user.currency ? Sso::Presenter::Currency.new(dto: @user.currency).present : nil,
      settings: UnifonicCloud::Auth::Service.new.settings
    }
  end
end
