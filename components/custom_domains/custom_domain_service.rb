class CustomDomains::CustomDomainService
  # include Common::Helpers::ServiceIdHelper
  include Common::Helpers::PaginationHelper

  def create(attributes:, check_enabled_api: false)
    user = Users::UserService.new.fetch_or_create_by_account_id(account_id: attributes[:account_id])
    return 'User Not Enabled' if check_enabled_api && !user.enabled_api

    attributes[:user_id] = user.id
    attributes[:status] = :un_verified
    attributes[:uuid] = SecureRandom.uuid
    custom_domain = CustomDomains::CustomDomain.new(attributes.except(:account_id))
    return create_dto(custom_domain) if custom_domain.save
    custom_domain.errors.full_messages.join(',')
  end

  def update(id:, attributes:)
    custom_domain = CustomDomains::CustomDomain.find_by(id: id)
    return nil unless custom_domain

    attributes[:status] = :un_verified
    custom_domain.assign_attributes(attributes)
    return create_dto(custom_domain) if custom_domain.save
    custom_domain.errors.full_messages.join(',')
  end

  def filter(criteria: {}, page: 1, per_page: 500, sort_by: :id, sort_direction: 'asc')
    custom_domains = CustomDomains::CustomDomain.where(nil).includes(:url_mappings)
    custom_domains = custom_domains.by_account_id(criteria[:account_id]) if criteria[:account_id].present?
    custom_domains = custom_domains.by_id(criteria[:id]) if criteria[:id].present?
    custom_domains = custom_domains.by_name(criteria[:name]) if criteria[:name].present?
    custom_domains = custom_domains.by_host(criteria[:host]) if criteria[:host].present?
    custom_domains = custom_domains.by_point_to(criteria[:point_to]) if criteria[:point_to].present?
    custom_domains = custom_domains.by_ssl_certificate(criteria[:ssl_certificate]) if criteria[:ssl_certificate].present?
    custom_domains = custom_domains.by_status(criteria[:status]) if criteria[:status].present?
    custom_domains = custom_domains.order(sort_by => sort_direction) if sort_by

    paginated_dtos(collection: custom_domains, page: page, per_page: per_page) do |custom_domain|
      create_dto(custom_domain)
    end
  end

  def verify_domain(id:)
    custom_domain = CustomDomains::CustomDomain.find_by(id: id)
    return unless custom_domain
    custom_domain.verified!

    create_dto(custom_domain)
  end

  def destroy(id:)
    custom_domain = CustomDomains::CustomDomain.find_by(id: id)
    custom_domain.destroy
    create_dto(custom_domain)
  end

  def fetch_by_uuid_status(uuid:)
    custom_domain = CustomDomains::CustomDomain.where(uuid: uuid, status: :verified).first
    return unless custom_domain
    create_dto(custom_domain)
  end

  def fetch_with_status(id:)
    custom_domain = CustomDomains::CustomDomain.where(id: id, status: :verified).first
    return unless custom_domain
    create_dto(custom_domain)
  end

  def fetch(id:)
    custom_domain = CustomDomains::CustomDomain.find_by(id: id)
    return unless custom_domain
    create_dto(custom_domain)
  end

  private

  def create_dto(custom_domain)
    CustomDomains::CustomDomainDto.new(
      id: custom_domain.id,
      user_id: custom_domain.user_id,
      account_id: custom_domain.user.account_id,
      name: custom_domain.name,
      host: custom_domain.host,
      point_to: custom_domain.point_to,
      ssl_certificate: custom_domain.ssl_certificate,
      status: custom_domain.status,
      uuid: custom_domain.uuid
    )
  end
end
