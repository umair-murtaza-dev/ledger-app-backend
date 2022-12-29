class Services::Api::V1::LinksController < Services::Api::V1::ApplicationController

  def create
    url_mapping = UrlMappings::UrlMappingService.new.create(attributes: check_data, check_enabled_api: true)
    if url_mapping.blank? || url_mapping.is_a?(String)
      Rails.logger.error("className: #{self}, error in creating tiny link , error #{url_mapping}")
      render json: { status: false, error: url_mapping || "Cannot create link" }, status: :bad_request
    else
      render json: Services::Presenter::Link.new(dto: url_mapping).present
    end
  end

  def ledger_details
    url_mapping = UrlMappings::UrlMappingService.new.fetch_by_redirect_key(redirect_key: params[:variable]) if params[:variable].present?
    url_mapping = UrlMappings::UrlMappingService.new.fetch_by_external_ref_id(external_ref_id: params[:external_ref_id]) if params[:external_ref_id].present?
    if url_mapping.blank? || url_mapping.is_a?(String)
      Rails.logger.error("className: #{self}, error in finding tiny link , error #{url_mapping}")
      render json: { status: false, error: url_mapping || "Cannot find link" }, status: :bad_request
    else
      render json: Services::Presenter::Link.new(dto: url_mapping).present
    end
  end

  private

  def permitted_params
    params.permit(:external_ref_id, :long_url, :title, :custom_domain_id, :tags)
  end

  def check_data
    {
      account_id: current_user.account_id,
      redirect_link: permitted_params[:long_url],
      title: permitted_params[:title],
      tags: permitted_params[:tags],
      custom_domain_id: permitted_params[:custom_domain_id],
      external_ref_id: permitted_params[:external_ref_id],
      trace_id: get_trace_id
      # remote_ip: request.remote_ip
    }
  end
end
