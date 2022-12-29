class Web::Api::V1::MappingsController < Web::Api::V1::ApplicationController
  include Common::Helpers::TranslationHelper
  before_action :set_user, only: [:index, :stats, :show, :report]
  before_action :set_mapping, except: [:index, :create, :stats, :show]

  def index
    return forbidden unless can?('TU', 'APP', ['SEE_OWN', 'SEE_ALL'])
    criteria = params[:criteria].present? ? params[:criteria] : {}
    criteria.merge!({ user_id: @user.id })

    params[:search] = params[:search].split("/").last if params[:search].present? && params[:search].count("/") == 3 && params[:search][-1] != "/"
    criteria.merge!(search: params[:search]) if params[:search].present?
    mappings = UrlMappings::UrlMappingService.new.filter(criteria: criteria, per_page: @per_page, page: @page, with_tags: params[:bulkurl_ref_id].present? ,with_bulk_request: params[:bulkurl_ref_id].present? || params[:external_ref_id].present?, with_history: true)
    render json: page_meta(mappings).merge({ data: mappings.map{|mapping| Web::Presenter::Mapping.new(dto: mapping).present }})
  end

  def report
    return forbidden unless can?('TU', 'APP', ['SEE_OWN', 'SEE_ALL'])
    report = UrlMappings::UrlMappingService.new.report(account_id: current_account_id)
    render json: Web::Presenter::Report.new(dto: report).present
  end

  def show
    return if current_account_id && !params[:id]
    @mapping = UrlMappings::UrlMappingService.new.filter(criteria: { external_ref_id: params[:external_ref_id], user_id: @user.id, uuid: params[:id] }, per_page: 1, with_tags: true, with_custom_domain: true ).first if params[:id].present?
    render json: :not_found unless @mapping
    render json: Web::Presenter::Mapping.new(dto: @mapping).present
  end

  def stats
    return if current_account_id && !params[:id]
    @mapping = UrlMappings::UrlMappingService.new.filter(criteria: { external_ref_id: params[:external_ref_id], user_id: @user.id, uuid: params[:id] }, per_page: 1, with_details: true, with_history: true).first if params[:id].present?
    render json: :not_found unless @mapping
    render json: Web::Presenter::MappingDetail.new(dto: @mapping).present
  end

  def create
    return forbidden unless can?('TU', 'APP', ['CREATE_OWN', 'CREATE_ALL'])
    @mapping = UrlMappings::UrlMappingService.new.create(attributes: permitted_params.merge(account_id: current_account_id))
    if @mapping.blank? || @mapping.is_a?(String)
      render json: { error: @mapping || 'App not found' }, status: :unprocessable_entity
    else
      render_mapping
    end
  end

  def update
    return forbidden unless can?('TU', 'APP', ['EDIT_OWN', 'EDIT_ALL'])
    @mapping = UrlMappings::UrlMappingService.new.update(uuid: @mapping.uuid, attributes: permitted_params)
    if @mapping.blank? || @mapping.is_a?(String)
      render json: { error: @mapping || 'App not found' }, status: :unprocessable_entity
    else
      render_mapping
    end
  end

  def destroy
    return forbidden unless can?('TU', 'APP', ['DELETE_OWN', 'DELETE_ALL'])
    @mapping = UrlMappings::UrlMappingService.new.destroy(uuid: @mapping.uuid)
    if @mapping.blank? || @mapping.is_a?(String)
      render json: { error: @mapping || 'App not found' }, status: :unprocessable_entity
    else
      render_mapping
    end
  end

  private

  def set_mapping
    return if current_account_id && !params[:id]
    @user ||= set_user
    @mapping = UrlMappings::UrlMappingService.new.filter(criteria: { external_ref_id: params[:external_ref_id], uuid: params[:id], user_id: @user.id, uuid: params[:id] }, per_page: 1).first if params[:id].present?
    head :not_found unless @mapping
  end

  def render_mapping
    render json: Web::Presenter::Mapping.new(dto: @mapping).present
  end

  def permitted_params
    params.permit(:external_ref_id, :title, :redirect_key, :redirect_link, :tags, :custom_domain_id)
  end
end
