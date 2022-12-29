class Reports::ReportService
  include Common::Helpers::ServiceIdHelper
  include Common::Helpers::PaginationHelper

  def create(attributes:, check_enabled_api: false)
    user = Users::UserService.new.fetch_or_create_by_account_id(account_id: attributes[:account_id])
    return 'User Not Enabled' if check_enabled_api && !user.enabled_api

    attributes[:user_id] = user.id
    attributes[:status] = 'in_progress'
    report = Reports::Report.new(attributes.except(:account_id))
    if report.save
      Reports::Worker::CreateCsvWorker.perform_async(report.id)
      return create_dto(report)
    end
    report.errors.full_messages.join(',')
  end

  def links_report(criteria: {}, page: 1, per_page: 10, sort_by: :id, sort_direction: 'desc')
    start_date = criteria[:startDate].present? ? criteria[:startDate]: Date.today - 30.days
    end_date = criteria[:endDate].present? ? criteria[:endDate]: Date.today + 1.day
    links = UrlMappings::UrlMapping.where(nil)
    links = links.by_account_id(criteria[:account_id]) if criteria[:account_id].present?
    links = links.where('Date (created_at) BETWEEN ? AND ?', start_date, end_date)
    links = links.select("count(url_mappings.id) AS links_count, ANY_VALUE(created_at) as created_at")
    links = links.group("date(created_at)")

    paginated_dtos(collection: links, page: page, per_page: per_page) do |link|
      Reports::ReportDto.new(
        date: link.created_at.strftime("%d-%b-%Y"),
        links_count: link[:links_count]
      )
    end
  end

  def clicks_report(criteria: {}, page: 1, per_page: 10, sort_by: :id, sort_direction: 'desc')
    start_date = criteria[:startDate].present? ? criteria[:startDate]: Date.today - 30.days
    end_date = criteria[:endDate].present? ? criteria[:endDate]: Date.today + 1.day
    clicks = Histories::History.where(nil)
    clicks = clicks.where('Date (created_at) BETWEEN ? AND ?', start_date, end_date)
    clicks = clicks.select("count(histories.id) AS clicks_count, ANY_VALUE(created_at) as created_at")
    clicks = clicks.group("date(created_at)")

    paginated_dtos(collection: clicks, page: page, per_page: per_page) do |click|
      Reports::ReportDto.new(
        date: click.created_at.strftime("%d-%b-%Y"),
        clicks_count: click[:clicks_count]
      )
    end
  end

  def bulk_request_report(criteria: {}, page: 1, per_page: 10, sort_by: :id, sort_direction: 'desc')
    bulk_requests = BulkRequests::BulkRequest.joins(:url_mappings)
    bulk_requests = bulk_requests.by_account_id(criteria[:account_id]) if criteria[:account_id].present?
    bulk_requests = bulk_requests.select("bulk_requests.external_ref_id AS title, bulk_requests.status AS status, count(url_mappings.id) AS links_count")
    bulk_requests = bulk_requests.group("bulk_requests.id")

    paginated_dtos(collection: bulk_requests, page: page, per_page: per_page) do |bulk_request|
      Reports::ReportDto.new(
        title: bulk_request[:title],
        links_count: bulk_request[:links_count],
        status: bulk_request[:status],
        duration: bulk_request[:duration] || '5 min',
      )
    end
  end

  private
  def create_dto(report)
    Reports::ReportDto.new(
      id: report.id,
      user_id: report.user_id,
      bulk_request_id: report.bulk_request_id,
      report_link: report.report_link,
      status: report.status,
    )
  end
end
