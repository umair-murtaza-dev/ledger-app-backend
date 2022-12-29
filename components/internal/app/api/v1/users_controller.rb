class Internal::App::Api::V1::UsersController < Internal::App::Api::V1::ApplicationController

  def auth_token
    return forbidden unless can?('TU', 'APP', ['SEE_OWN', 'SEE_ALL'])
    user = Users::UserService.new.fetch_or_create_by_account_id(account_id: current_account_id)
    user = Users::UserService.new.update(id: user.id, attributes: {enabled: true}) unless user.blank?
    if user.blank? || user.is_a?(String)
      Rails.logger.error("className: #{self}, error in fetch urls, error #{user}")
      render json: { error: user || 'User not found' }, status: :unprocessable_entity
    else
      render json: { token: user.auth_token}, status: :ok
    end
  end
end
