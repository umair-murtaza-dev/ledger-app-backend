class Users::UserService
  include Common::Helpers::PaginationHelper

  def fetch_or_create_by_account_id(account_id: )
    user = Users::User.find_by(account_id: account_id)
    user ||= Users::User.create(account_id: account_id, auth_token: get_token(account_id: account_id)[:token])
    return nil unless user.try(:id)
    create_dto(user)
  end

  def update(id:, attributes:)
    user = Users::User.find_by(id: id)
    return nil unless user
    user.assign_attributes(attributes)
    return create_dto(user) if user.save
    user.errors.full_messages.join(',')
  end

  def filter(criteria: {}, page: 1, per_page: 50, sort_by: :id, sort_direction: 'desc', with_details: false, with_tags: false)
    users = Users::User.where(nil)
    users = users.by_account_id(criteria[:id]) if criteria[:id].present?
    # users = users.by_id(criteria[:id]) if criteria[:id].present?
    users = users.order(sort_by => sort_direction) if sort_by

    paginated_dtos(collection: users, page: page, per_page: per_page) do |user|
      create_dto(user)
    end
  end

  def fetch_by_token(token:)
    user = Users::User.find_by(auth_token: token)
    return nil unless user
    create_dto(user)
  end

  private

  def create_dto(user)
    Users::UserDto.new(
      id: user.id,
      account_id: user.account_id,
      auth_token: user.auth_token,
      enabled: user.enabled,
      enabled_api: user.enabled,
      api_link: api_link,
      documetation: documentation_link,
    )
  end

  def get_token(account_id:)
    { token: authenticator(account_id: account_id).generate_app_token(account_id: account_id) }
  end

  def authenticator(account_id:)
    Common::Helpers::Authenticator.new(secret: account_id)
  end

  def api_link
    ENV['ledger_api_link']
  end

  def documentation_link
    ENV['ledger_documentation_link']
  end
end
