class Web::Api::V1::BulkRequestsController < Web::Api::V1::ApplicationController
  include Common::Helpers::TranslationHelper

  def index
    return forbidden unless can?('TU', 'APP', ['SEE_OWN', 'SEE_ALL'])
    criteria = params[:criteria].present? ? params[:criteria] : {}
    criteria.merge!({ account_id: current_account_id })
    criteria.merge!(search: params[:search]) if params[:search].present?
    bulk_requests = BulkRequests::BulkRequestService.new.filter(criteria: criteria, per_page: @per_page, page: @page)
    render json: page_meta(bulk_requests).merge({ data: bulk_requests.map{|bulk_request| Web::Presenter::BulkRequest.new(dto: bulk_request).present }})
  end

  def create
    return forbidden unless can?('TU', 'APP', ['CREATE_OWN', 'CREATE_ALL'])
    params[:file] = params[:bulk_request_file]
    bulk_request = BulkRequests::BulkRequestService.new.create(attributes: permitted_params.merge(account_id: current_account_id))
    if bulk_request.blank? || bulk_request.is_a?(String)
      render json: { error: bulk_request || 'Bulk Request not created' }, status: :unprocessable_entity
    else
      render json: Web::Presenter::BulkRequest.new(dto: bulk_request).create_present
    end
  end

  def fetch_urls
    return forbidden unless can?('TU', 'APP', ['SEE_OWN', 'SEE_ALL'])
    criteria = { external_ref_id: params[:external_ref_id], bulkurl_ref_id: params[:bulkurl_ref_id] }
    bulk_requests = BulkRequests::BulkRequestService.new.filter(criteria: criteria, per_page: @per_page, page: @page)
    if bulk_requests.blank? || bulk_requests.is_a?(String)
      render json: { error: bulk_requests || 'Bulk Request not found' }, status: :unprocessable_entity
    else
      render json: page_meta(bulk_requests).merge({ data: bulk_requests.map{|bulk_request| Web::Presenter::BulkRequest.new(dto: bulk_request).fetch_urls }})
    end
  end

  def get_status
    return forbidden unless can?('TU', 'APP', ['SEE_OWN', 'SEE_ALL'])
    criteria = { external_ref_id: params[:external_ref_id], bulkurl_ref_id: params[:bulkurl_ref_id] }
    bulk_request = BulkRequests::BulkRequestService.new.fetch_by_ref_id(criteria: criteria)
    if bulk_request.blank? || bulk_request.is_a?(String)
      render json: { error: bulk_request || 'Bulk Request not found' }, status: :unprocessable_entity
    else
      render json: Internal::Presenter::BulkRequest.new(dto: bulk_request).get_status
    end
  end

  private

  def permitted_params
    params.permit(:external_ref_id, :long_url, :file, :webhook_url, :email, :custom_domain_id)
  end
end
