class BulkRequests::BulkRequestService
  include Common::Helpers::ServiceIdHelper
  include Common::Helpers::PaginationHelper
  include Concurrent::Async

  def create(attributes:, check_enabled_api: false)
    user = Users::UserService.new.fetch_or_create_by_account_id(account_id: attributes[:account_id])
    return 'User Not Enabled' if check_enabled_api && !user.enabled_api
    return "File size should be less then 85MB" if attributes[:file].present? && attributes[:file].size >= 85.megabytes
    # return "File data invalid" if attributes[:file].present? && !File.new(attributes[:file], "r:ISO-8859-1:UTF-8").grep(/(^,(,|$))/).blank?
    if attributes[:custom_domain_id].present?
      custom_domain = fetch_custom_domain(attributes[:custom_domain_id])
      return "Invalid Custom Domain Id" unless custom_domain
      attributes[:custom_domain_id] = custom_domain.id
    end
    attributes[:user_id] = user.id
    attributes[:bulkurl_ref_id] = SecureRandom.uuid
    attributes[:source] = 0
    attributes[:status] = 0
    bulk_request = BulkRequests::BulkRequest.new(attributes.except(:account_id))
    if bulk_request.save
      Thread.new {
        BulkRequests::Worker::ParseCsvWorker.new.perform(bulk_request.id)
      }
      return create_dto(bulk_request,without_details_urls: true)
    end
    bulk_request.errors.full_messages.join(',')
  end

  def filter(criteria: {}, page: 1, per_page: 500, sort_by: :id, sort_direction: 'desc', with_tags: false)
    bulk_requests = BulkRequests::BulkRequest.where(nil)
    bulk_requests = bulk_requests.includes(url_mappings: [url_mapping_tags: :tag]) if with_tags.present?
    bulk_requests = bulk_requests.by_account_id(criteria[:account_id]) if criteria[:account_id].present?
    bulk_requests = bulk_requests.where("LOWER(external_ref_id) = ? OR bulkurl_ref_id = ?", criteria[:search]&.downcase, criteria[:search]) if criteria[:search].present?
    bulk_requests = bulk_requests.by_external_ref_id(criteria[:external_ref_id]) if criteria[:external_ref_id].present?
    bulk_requests = bulk_requests.by_bulkurl_ref_id(criteria[:bulkurl_ref_id]) if criteria[:bulkurl_ref_id].present?
    bulk_requests = bulk_requests.by_long_url(criteria[:long_url]) if criteria[:long_url].present?
    bulk_requests = bulk_requests.by_email(criteria[:email]) if criteria[:email].present?
    bulk_requests = bulk_requests.by_status(criteria[:status]) if criteria[:status].present?
    bulk_requests = bulk_requests.by_csv_status(criteria[:csv_status]) if criteria[:csv_status].present?
    bulk_requests = bulk_requests.by_source(criteria[:source]) if criteria[:source].present?
    bulk_requests = bulk_requests.by_trace_id(criteria[:trace_id]) if criteria[:trace_id].present?
    bulk_requests = bulk_requests.order(sort_by => sort_direction) if sort_by

    paginated_dtos(collection: bulk_requests, page: page, per_page: per_page) do |bulk_request|
      create_dto(bulk_request,without_details_urls: true)
    end
  end

  def destroy(id:)
    bulk_request = BulkRequests::BulkRequest.find_by(id: id)
    create_dto(bulk_request,without_details_urls: true)
  end

  def fetch_by_ref_id(criteria: {})
    bulk_request = BulkRequests::BulkRequest.find_by(external_ref_id: criteria[:external_ref_id]) if criteria[:external_ref_id].present?
    bulk_request = BulkRequests::BulkRequest.find_by(bulkurl_ref_id: criteria[:bulkurl_ref_id]) if criteria[:bulkurl_ref_id].present? && bulk_request.nil?
    return unless bulk_request

    create_dto(bulk_request,without_details_urls: true)
  end

  def fetch_by_trace_id(criteria: {})
    bulk_request = BulkRequests::BulkRequest.find_by(trace_id: criteria[:trace_id]) if criteria[:trace_id].present?
    return unless bulk_request

    create_dto(bulk_request,without_details_urls: true)
  end

  def update_email(criteria: {})
    bulk_request = BulkRequests::BulkRequest.find_by(external_ref_id: criteria[:external_ref_id]) if criteria[:external_ref_id].present?
    bulk_request = BulkRequests::BulkRequest.find_by(bulkurl_ref_id: criteria[:bulkurl_ref_id]) if criteria[:bulkurl_ref_id].present? && bulk_request.nil?
    return unless bulk_request
    if bulk_request.update(email: criteria[:email] || bulk_request.email, csv_status: 'processing')
      bulk_request.reload
      BulkRequests::Worker::CreateCsvWorker.perform_async(bulk_request.id)
      create_dto(bulk_request,without_details_urls: true)
    else
      raise bulk_request.errors.full_messages.join(',')
    end
  end

  def fetch(id:)
    bulk_request = BulkRequests::BulkRequest.find_by(id: id)
    return unless bulk_request
    create_dto(bulk_request,without_details_urls: true)
  end

  private

  def detailed_urls(bulk_request)
    url_mappings = []
    bulk_request.url_mappings.find_each(batch_size: 5000) do |mapping|
      url_mappings << { reference_id: mapping.title, tags:  mapping.mapping_tags, "short_url": "#{mapping.host_url}#{mapping.redirect_key}", "id": mapping.redirect_key, clicks: mapping.allowed_hits.to_i - mapping.remaining_hits.to_i}
    end
    url_mappings
  end

  def create_dto(bulk_request, without_details_urls: false)
    BulkRequests::BulkRequestDto.new(
      id: bulk_request.id,
      user_id: bulk_request.user_id,
      external_ref_id: bulk_request.external_ref_id,
      long_url: bulk_request.long_url,
      bulkurl_ref_id: bulk_request.bulkurl_ref_id,
      webhook_url: bulk_request.webhook_url,
      email: bulk_request.email,
      csv_link: bulk_request.csv_link,
      status: bulk_request.status,
      csv_status: bulk_request.csv_status,
      source: bulk_request.source,
      urls: without_details_urls ? [] : detailed_urls(bulk_request),
      report_status: bulk_request.reports.last&.status,
      report_link: bulk_request.reports.last&.report_link,
      custom_domain_id: bulk_request.custom_domain_id,
      trace_id: bulk_request.trace_id
    )
  end

  def fetch_custom_domain(custom_domain_id)
    custom_domain = CustomDomains::CustomDomainService.new.fetch_with_status(id: custom_domain_id)
    custom_domain = CustomDomains::CustomDomainService.new.fetch_by_uuid_status(uuid: custom_domain_id) unless custom_domain
    return unless custom_domain
    custom_domain
  end
end
