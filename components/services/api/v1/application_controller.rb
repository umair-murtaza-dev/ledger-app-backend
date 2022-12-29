class Services::Api::V1::ApplicationController < ActionController::API
  include ActionController::Caching
  include Common::Helpers::PageMetaHelper
  include Common::Helpers::ExceptionHandlerHelper

  before_action :authenticate!
  before_action :prepare_exception_notifier
  before_action :set_format
  before_action :set_pagination
  before_action :set_locale

  def set_format
    request.format = :json
  end

  def set_pagination
    @page = get_page(params[:page])
    @per_page = get_per_page(params[:per_page])
  end

  def set_locale
    if params[:locale].present?
      @current_locale = params[:locale].to_s
    else
      @current_locale = I18n.default_locale
    end
  end

  def current_locale
    @current_locale
  end

  def authenticate!
    return render json: { error: 'Invalid User' }, status: :bad_request unless current_user
    return render json: { error: 'Disabled User' }, status: :bad_request if current_user && !current_user.enabled
  end

  def current_user
    return @user if @user
    token = get_token
    return if token.blank?
    @user = Users::UserService.new.fetch_by_token(token: token)
    @user
  end

  def get_trace_id
    request.headers['HTTP_X_B3_TRACEID']
  end

  private

  def get_token
    request.headers['Authorization'].present? ? request.headers['Authorization'].to_s.split('Bearer ').last : nil
  end

end
