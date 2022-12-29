class Internal::Api::V1::BulkRequestsController < Internal::Api::V1::ApplicationController
  include Common::Helpers::TranslationHelper

  def index
    criteria = params[:criteria].present? ? params[:criteria] : {}
    criteria.merge!({ account_id: current_account_id })
    bulk_requests = BulkRequests::BulkRequestService.new.filter(criteria: criteria, per_page: @per_page, page: @page, with_tags: false)
    render json: page_meta(bulk_requests).merge({ data: bulk_requests.map{|bulk_request| Internal::Presenter::BulkRequest.new(dto: bulk_request).present }})
  end

  def create
    trace_id = get_trace_id
    bulk_request = BulkRequests::BulkRequestService.new.create(attributes: permitted_params.merge(account_id: current_account_id, trace_id: trace_id))
    if bulk_request.blank? || bulk_request.is_a?(String)
      Rails.logger.error("className: #{self}, error in creating create bulk request, error #{bulk_request}")
      render json: { error: bulk_request || 'Bulk Request not created' }, status: :unprocessable_entity
    else
      render json: Internal::Presenter::BulkRequest.new(dto: bulk_request).create_present
    end
  end

  def fetch_urls
    criteria = { external_ref_id: params[:external_ref_id], bulkurl_ref_id: params[:bulkurl_ref_id], trace_id: params[:trace_id] }
    bulk_requests = BulkRequests::BulkRequestService.new.filter(criteria: criteria, per_page: @per_page, page: @page, with_tags: false)
    if bulk_requests.blank? || bulk_requests.is_a?(String)
      Rails.logger.error("className: #{self}, error in fetch urls, error #{bulk_requests}")
      render json: { error: bulk_requests || 'Bulk Request not found' }, status: :unprocessable_entity
    else
      render json: page_meta(bulk_requests).merge({ data: bulk_requests.map{|bulk_request| Internal::Presenter::BulkRequest.new(dto: bulk_request).fetch_urls }})
    end
  end

  def fetch_by_ref_id
    criteria = { external_ref_id: params[:external_ref_id], bulkurl_ref_id: params[:bulkurl_ref_id], reference_id: params[:reference_id] }
    bulk_request = BulkRequests::BulkRequestService.new.fetch_by_ref_id(criteria: criteria)
    if bulk_request.blank? || bulk_request.is_a?(String)
      Rails.logger.error("className: #{self}, error in fetch by ref ids, error #{bulk_request}")
      render json: { error: bulk_request || 'Bulk Request not created' }, status: :unprocessable_entity
    else
      render json: Internal::Presenter::BulkRequest.new(dto: bulk_request).ref_id_present(url_mapping: bulk_request.urls.select{|ul| ul[:reference_id] == criteria[:reference_id]}.first)
    end
  end

  def get_status
    criteria = { external_ref_id: params[:external_ref_id], bulkurl_ref_id: params[:bulkurl_ref_id] }
    bulk_request = BulkRequests::BulkRequestService.new.fetch_by_ref_id(criteria: criteria)
    if bulk_request.blank? || bulk_request.is_a?(String)
      render json: { error: bulk_request || 'Bulk Request not found' }, status: :unprocessable_entity
    else
      render json: Internal::Presenter::BulkRequest.new(dto: bulk_request).get_status
    end
  end

  def create_csv
    criteria = { external_ref_id: params[:external_ref_id], bulkurl_ref_id: params[:bulkurl_ref_id], email: params[:email] }
    bulk_request = BulkRequests::BulkRequestService.new.update_email(criteria: criteria)
    if bulk_request.blank? || bulk_request.is_a?(String)
      Rails.logger.error("className: #{self}, error in create csv, error #{bulk_request}")
      render json: { error: bulk_request || 'Bulk Request not created' }, status: :unprocessable_entity
    else
      render json: { status: true }
    end
  end

  private

  def permitted_params
    params.permit(:external_ref_id, :long_url, :file, :webhook_url, :email, :custom_domain_id)
  end
end
