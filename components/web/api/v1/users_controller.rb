class Web::Api::V1::UsersController < Web::Api::V1::ApplicationController
  include Common::Helpers::TranslationHelper
  before_action :set_history, except: [:index, :create]

  # def index
  #   return forbidden unless can?('TU', 'MAPPING', ['SEE_OWN', 'SEE_ALL'])
  #   criteria = params[:criteria].present? ? params[:criteria] : {}
  #   criteria.merge!({ url_mapping_id: params[:url_mapping_id] })
  #   histories = Histories::HistoryService.new.filter(criteria: criteria, per_page: @per_page, page: @page)
  #   render json: page_meta(histories).merge({ data: histories.map{|history| Web::Presenter::History.new(dto: history).present }})
  # end

  def show
    render_user
  end

  def update
    @user = Users::UserService.new.update(id: @user.id, attributes: permitted_params)
    if @user.blank? || @user.is_a?(String)
      render json: { error: @user || 'User not found' }, status: :unprocessable_entity
    else
      render_user
    end
  end

  private

  def set_history
    return if current_account_id && !params[:id]
    @user = Users::UserService.new.filter(criteria: { id: params[:id] }, per_page: 1).first if params[:id].present?
    head :not_found unless @user
  end

  def permitted_params
    params.permit(:account_id, :enabled)
  end

  def render_user
    render json: Web::Presenter::User.new(dto: @user).present
  end

end
