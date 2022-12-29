class Internal::App::Api::V1::CustomDomainsController < Internal::App::Api::V1::ApplicationController
  include Common::Helpers::TranslationHelper

  def index
    criteria = params[:criteria].present? ? params[:criteria] : {}
    criteria.merge!({ account_id: current_user.account_id, status: :verified })
    mappings = CustomDomains::CustomDomainService.new.filter(criteria: criteria, per_page: @per_page, page: @page)
    render json: page_meta(mappings).merge({ data: mappings.map{|mapping| Internal::Presenter::CustomDomain.new(dto: mapping).present }})
  end
end
