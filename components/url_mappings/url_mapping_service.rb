class UrlMappings::UrlMappingService
  include Common::Helpers::ServiceIdHelper
  include Common::Helpers::PaginationHelper

  def create(attributes:, check_enabled_api: false)
    user = Users::UserService.new.fetch_or_create_by_account_id(account_id: attributes[:account_id])
    return 'User Not Enabled' if check_enabled_api && !user.enabled_api
    host_url =  if attributes[:custom_domain_id]
      custom_domain = fetch_custom_domain(attributes[:custom_domain_id])
      return "Invalid Custom Domain ID" unless custom_domain
      attributes[:custom_domain_id] = custom_domain&.id
      custom_domain.host
    else
      fetch_host_url
    end
    attributes[:user_id] = user.id
    attributes[:redirect_key] = generate_redirect_key
    attributes[:host_url] = host_url.last.eql?('/') ? host_url : (host_url + '/')
    attributes[:uuid] = MySQLBinUUID::Type.new.cast(SecureRandom.uuid.encode(Encoding::ASCII_8BIT))
    attributes[:allowed_hits] = get_allowed_hits # TODO move to secrets
    attributes[:remaining_hits] = attributes[:allowed_hits]
    attributes[:mapping_tags] = attributes[:tags]
    attributes[:created_at_unix] = DateTime.current.to_i

    mapping = UrlMappings::UrlMapping.new(attributes.except(:account_id, :tags))
    Rails.logger.info("before save tiny url#{attributes}")

    return create_dto(mapping) if mapping.save
    mapping.errors.full_messages.join(',')
  end

  def update(uuid:, attributes:)
    mapping = UrlMappings::UrlMapping.find_by(uuid: uuid)
    return nil unless mapping

    attributes[:mapping_tags] = attributes[:tags]
    mapping.assign_attributes(attributes.except(:tags))
    return create_dto(mapping) if mapping.save
    mapping.errors.full_messages.join(',')
  end

  def filter(criteria: {}, page: 1, per_page: 50, sort_by: :id, sort_direction: 'desc', with_details: false, with_tags: false, with_history: false, with_bulk_request: false, with_custom_domain: false)
    mappings = UrlMappings::UrlMapping.where(nil)
    mappings = mappings.without_bulk_request if with_bulk_request != true
    mappings = mappings.includes(:histories).references(:histories) if with_history == true
    mappings = mappings.includes(:custom_domain).references(:custom_domain) if with_custom_domain == true
    mappings = mappings.by_uuid(criteria[:uuid]) if criteria[:uuid].present?
    mappings = mappings.where("uuid = ? OR external_ref_id = ? OR redirect_key = ? OR LOWER(title) = ? OR redirect_link = ?", criteria[:search], criteria[:search], criteria[:search], criteria[:search].downcase, criteria[:search]) if criteria[:search].present?
    mappings = mappings.by_id(criteria[:url_mapping_id]) if criteria[:url_mapping_id].present?
    mappings = mappings.by_external_ref_id(criteria[:external_ref_id]) if criteria[:external_ref_id].present?
    mappings = mappings.by_bulkrequest_external_ref_id(criteria[:external_ref_id]) if criteria[:external_ref_id].present?
    mappings = mappings.by_bulkurl_ref_id(criteria[:bulkurl_ref_id]) if criteria[:bulkurl_ref_id].present?
    mappings = mappings.by_user_id(criteria[:user_id]) if criteria[:user_id].present?
    mappings = mappings.by_redirect_key(criteria[:redirect_key]) if criteria[:redirect_key].present?
    mappings = mappings.by_title(criteria[:title]) if criteria[:title].present?
    mappings = mappings.by_trace_id(criteria[:trace_id]) if criteria[:trace_id].present?
    mappings = mappings.order(sort_by => sort_direction) if sort_by

    paginated_dtos(collection: mappings, page: page, per_page: per_page) do |mapping|
      with_details == true ? details_dto(mapping, with_history) : create_dto(mapping, with_details, with_tags, with_history, with_custom_domain)
    end
  end

  def report(account_id:)
    mappings = UrlMappings::UrlMapping.where(nil)
    mappings = mappings.by_account_id(:account_id)
    mappings = mappings.includes(:histories)
    mappings
  end

  def destroy(uuid:)
    mapping = UrlMappings::UrlMapping.find_by(uuid: id)
    mapping.destroy
    create_dto(mapping)
  end

  def mark_visit(redirect_key:)
    mapping = UrlMappings::UrlMapping.find_by(redirect_key: redirect_key)
    return unless mapping
    mapping.decrement!(:remaining_hits) if mapping.remaining_hits.to_i > 0
    create_dto(mapping)
  end

  def fetch_locations(mapping:)
    get_locations(mapping) || []
  end

  def fetch_by_redirect_key(redirect_key:)
    mapping = UrlMappings::UrlMapping.find_by(redirect_key: redirect_key)
    return unless mapping
    create_dto(mapping)
  end

  def fetch_by_external_ref_id(external_ref_id:)
    mapping = UrlMappings::UrlMapping.find_by(external_ref_id: external_ref_id)
    return unless mapping
    create_dto(mapping)
  end

  private

  def details_dto(mapping, with_history=false)
    UrlMappings::UrlMappingDto.new(
      id: mapping.uuid,
      details: details_presenter(mapping)
    )
  end

  def details_presenter(mapping)
    tags = { name: "tags", label: "Related Tags", type: "array", value: mapping.mapping_tags } if mapping.mapping_tags.present?
    details = [
      { name: "Name", label: "Title", type: "integer", value: mapping.title }
    ]
    return details.push(tags) if  mapping.mapping_tags.present?
    details
  end

  def get_locations(mapping)
    return nil unless mapping.histories.present?
    mapping.histories.pluck(:country)
  end

  def create_dto(mapping, with_details=false, with_tags=false,with_history=false,with_custom_domain=false)
    UrlMappings::UrlMappingDto.new(
      id: mapping.uuid,
      user_id: mapping.user_id,
      title: mapping.title,
      host_url: mapping.host_url,
      redirect_link: mapping.redirect_link,
      redirect_key: mapping.redirect_key,
      external_ref_id: mapping.external_ref_id,
      uuid: mapping.uuid,
      org_id: mapping.uuid,
      allowed_hits: mapping.allowed_hits,
      remaining_hits: mapping.remaining_hits,
      allowed_to_hit: mapping.remaining_hits.to_i > 0,
      clicks: mapping.allowed_hits.to_i - mapping.remaining_hits.to_i,
      mapping_tags: mapping.mapping_tags,
      tags: mapping.mapping_tags ? mapping.mapping_tags : '',
      campaign_id: mapping.bulk_request&.external_ref_id,
      long_url: mapping.bulk_request&.long_url,
      ref_id: mapping.ref_id,
      old_id: mapping.id,
      details: with_details ? details_presenter(mapping) : [],
      click_time: with_history &&  mapping.histories.any? ? mapping.histories.last&.created_at: nil,
      locations: get_locations(mapping) || [],
      trace_id: mapping.trace_id,
      updated_at: mapping.updated_at,
      location: mapping.histories.any? ? mapping.histories.first.country : nil,
      bulk_request_id: mapping.bulk_request_id,
      custom_domain: with_custom_domain == true ? mapping.custom_domain.present? ? mapping.custom_domain.host : nil : nil
    )
  end
  

  def fetch_host_url
    ENV['ledger_host_url']
  end

  def generate_redirect_key
    SecureRandom.hex( ENV['ledger_redirect_key_length'].to_i || 3)
  end

  def get_allowed_hits
    Rails.application.credentials.allowed_number_of_hits || 999999
  end


  def fetch_custom_domain(custom_domain_uuid)
    custom_domain = CustomDomains::CustomDomainService.new.fetch_by_uuid_status(uuid: custom_domain_uuid)
    return unless custom_domain
    custom_domain
  end
end
