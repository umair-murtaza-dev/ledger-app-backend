class Web::Api::V1::CustomDomainsController < Web::Api::V1::ApplicationController
  include Common::Helpers::TranslationHelper

  before_action :set_user, only: :index
  before_action :set_custom_domain, except: [:index, :create, :show]

  def index
    return forbidden unless can?('TU', 'APP', ['SEE_OWN', 'SEE_ALL'])
    criteria = params[:criteria].present? ? params[:criteria] : {}
    criteria.merge!({ account_id: current_account_id, status: :verified }) if params[:account_admin]
    mappings = CustomDomains::CustomDomainService.new.filter(criteria: criteria, per_page: @per_page, page: @page)
    render json: page_meta(mappings).merge({ data: mappings.map{|mapping| Web::Presenter::CustomDomain.new(dto: mapping).present }})
  end

  def show
    return if current_account_id && !params[:id]
    @custom_domain = CustomDomains::CustomDomainService.new.filter(criteria: { id: params[:id] }, per_page: 1 ).first if params[:id].present?
    render json: :not_found unless @custom_domain
    render json: Web::Presenter::CustomDomain.new(dto: @custom_domain).present
  end

  def create
    return forbidden unless can?('TU', 'APP', ['CREATE_OWN', 'CREATE_ALL'])
    @custom_domain = CustomDomains::CustomDomainService.new.create(attributes: permitted_params)
    if @custom_domain.blank? || @custom_domain.is_a?(String)
      render json: { error: @custom_domain || 'Domain not found' }, status: :unprocessable_entity
    else
      render_custom_domain
    end
  end

  def update
    return forbidden unless can?('TU', 'APP', ['EDIT_OWN', 'EDIT_ALL'])
    @custom_domain = CustomDomains::CustomDomainService.new.update(id: @custom_domain.id, attributes: permitted_params)
    if @custom_domain.blank? || @custom_domain.is_a?(String)
      render json: { error: @custom_domain || 'Domain not found' }, status: :unprocessable_entity
    else
      render_custom_domain
    end
  end

  def verify
    return forbidden unless can?('TU', 'APP', ['EDIT_OWN', 'EDIT_ALL'])
    @custom_domain = CustomDomains::CustomDomainService.new.verify_domain(id: @custom_domain.id)
    if @custom_domain.blank? || @custom_domain.is_a?(String)
      render json: { error: @custom_domain || 'Domain not found' }, status: :unprocessable_entity
    else
      render_custom_domain
    end
  end

  def destroy
    return forbidden unless can?('TU', 'APP', ['DELETE_OWN', 'DELETE_ALL'])
    @custom_domain = CustomDomains::CustomDomainService.new.destroy(id: @custom_domain.id)
    if @custom_domain.blank? || @custom_domain.is_a?(String)
      render json: { error: @custom_domain || 'Domain not found' }, status: :unprocessable_entity
    else
      render_custom_domain
    end
  end

  private

  def set_custom_domain
    return if current_account_id && !params[:id]
    @custom_domain = CustomDomains::CustomDomainService.new.filter(criteria: { id: params[:id], account_id: current_account_id }, per_page: 1).first if params[:id].present?
    head :not_found unless @custom_domain
  end

  def render_custom_domain
    render json: Web::Presenter::CustomDomain.new(dto: @custom_domain).present
  end

  def permitted_params
    params.permit(:name, :host, :point_to, :ssl_certificate, :account_id)
  end
end
