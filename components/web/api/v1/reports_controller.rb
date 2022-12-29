class Web::Api::V1::ReportsController < Web::Api::V1::ApplicationController
  include Common::Helpers::TranslationHelper

  def create
    return forbidden unless can?('TU', 'APP', ['CREATE_OWN', 'CREATE_ALL'])
    report = Reports::ReportService.new.create(attributes: permitted_params.merge(account_id: current_account_id))
    if report.blank? || report.is_a?(String)
      render json: { error: report || 'Bulk Request not created' }, status: :unprocessable_entity
    else
      render json: Web::Presenter::BulkRequestReport.new(dto: report).present
    end
  end

  def links_report
    return forbidden unless can?('TU', 'APP', ['CREATE_OWN', 'CREATE_ALL'])
    reports = Reports::ReportService.new.links_report(criteria: report_permitted_params, per_page: @per_page, page: @page)

    render json: page_meta(reports).merge({ data: reports.map{|report| Web::Presenter::LinksReport.new(report: report).present }})
  end

  def clicks_report
    return forbidden unless can?('TU', 'APP', ['CREATE_OWN', 'CREATE_ALL'])
    reports = Reports::ReportService.new.clicks_report(criteria: report_permitted_params, per_page: @per_page, page: @page)

    render json: page_meta(reports).merge({ data: reports.map{|report| Web::Presenter::ClicksReport.new(report: report).present }})
  end

  def bulk_request_report
    return forbidden unless can?('TU', 'APP', ['CREATE_OWN', 'CREATE_ALL'])
    reports = Reports::ReportService.new.bulk_request_report(criteria: report_permitted_params, per_page: @per_page, page: @page)

    render json: page_meta(reports).merge({ data: reports.map{|report| Web::Presenter::BulkReqReport.new(report: report).present }})
  end

  private

  def permitted_params
    params.permit(:bulk_request_id)
  end

  def report_permitted_params
    params.permit(:startDate, :endDate, :account_id)
  end
end
