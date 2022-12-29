class Web::Api::V1::TagsController < Web::Api::V1::ApplicationController
  include Common::Helpers::TranslationHelper
  before_action :set_tag, except: [:index, :create]

  def index
    return forbidden unless can?('TU', 'APP', ['SEE_OWN', 'SEE_ALL'])
    criteria = params[:criteria].present? ? params[:criteria] : {}
    criteria.merge!({ account_id: current_account_id })
    tags = Tags::TagService.new.filter(criteria: criteria, per_page: @per_page, page: @page)
    render json: page_meta(tags).merge({ data: tags.map{|tag| Web::Presenter::Tag.new(dto: tag).present }})
  end

  def show
    render_tag
  end

  def create
    return forbidden unless can?('TU', 'APP', ['CREATE_OWN', 'CREATE_ALL'])
    @tag = Tags::TagService.new.create(attributes: permitted_params.merge(account_id: current_account_id))
    if @tag.blank? || @tag.is_a?(String)
      render json: { error: @tag || 'App not found' }, status: :unprocessable_entity
    else
      render_tag
    end
  end

  def update
    return forbidden unless can?('TU', 'APP', ['EDIT_OWN', 'EDIT_ALL'])
    @tag = Tags::TagService.new.update(id: @tag.id, attributes: permitted_params)
    if @tag.blank? || @tag.is_a?(String)
      render json: { error: @tag || 'App not found' }, status: :unprocessable_entity
    else
      render_tag
    end
  end

  def destroy
    return forbidden unless can?('TU', 'APP', ['DELETE_OWN', 'DELETE_ALL'])
    @tag = Tags::TagService.new.destroy(id: @tag.id)
    if @tag.blank? || @tag.is_a?(String)
      render json: { error: @tag || 'App not found' }, status: :unprocessable_entity
    else
      render_tag
    end
  end

  private

  def set_tag
    return if current_account_id && !params[:id]
    @tag = Tags::TagService.new.filter(criteria: { uuid: params[:id], account_id: current_account_id }, per_page: 1).first if params[:id].present?
    head :not_found unless @tag
  end

  def render_tag
    render json: Web::Presenter::Tag.new(dto: @tag).present
  end

  def permitted_params
    params.permit(:url_tag_id, :title, :redirect_link)
  end
end
