class Web::Api::V1::HistoriesController < Web::Api::V1::ApplicationController
  include Common::Helpers::TranslationHelper
  before_action :set_history, except: [:index, :create]

  def index
    return forbidden unless can?('TU', 'APP', ['SEE_OWN', 'SEE_ALL'])
    criteria = params[:criteria].present? ? params[:criteria] : {}
    criteria.merge!({ url_mapping_id: params[:url_mapping_id] })
    histories = Histories::HistoryService.new.filter(criteria: criteria, per_page: @per_page, page: @page)
    render json: page_meta(histories).merge({ data: histories.map{|history| Web::Presenter::History.new(dto: history).present }})
  end

  def show
    render_history
  end
  private

  def set_history
    return if current_account_id && !params[:id]
    @history = Historiess::HistoriesService.new.filter(criteria: { uuid: params[:id] }, per_page: 1).first if params[:id].present?
    head :not_found unless @history
  end

  def render_history
    render json: Web::Presenter::History.new(dto: @history).present
  end

  def permitted_params
    params.permit(:title, :redirect_link, :redirect_key)
  end
end
