class Internal::App::Api::V1::LinksController < Internal::App::Api::V1::ApplicationController

    def ledger_details
      # url_mapping = UrlMappings::UrlMapping.find_by(redirect_key: params[:variable])
      # url_mapping = UrlMappings::UrlMapping.find_by(redirect_key: params[:variable])
      url_mapping = UrlMappings::UrlMappingService.new.fetch_by_redirect_key(redirect_key: params[:variable])
      if url_mapping.blank? || url_mapping.is_a?(String)
        Rails.logger.error("className: #{self}, error in finding tiny link , error #{url_mapping}")
        render json: { status: false, error: url_mapping || "Cannot find link" }, status: :bad_request
      else
        render json: Internal::Presenter::Link.new(dto: url_mapping).present
      end
    end

    private

    def permitted_params
      params.permit(:long_url, :title, :custom_domain_id)
    end
end
