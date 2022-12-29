class Internal::App::Api::V1::ApplicationController < ActionController::API
  include Sso::Api::V1::JwtAuthenticationHelper
  include Common::Helpers::ExceptionHandlerHelper
  include Common::Helpers::PageMetaHelper
  include ActionController::Caching

  before_action :authenticate!
  before_action :prepare_exception_notifier
  before_action :set_format
  before_action :set_pagination
  before_action :set_locale
  before_action :set_paper_trail_whodunnit

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

  def current_account_id
    current_account&.id || @current_account_id || "096dbece-f82e-11e8-809b-0252151e4411"
  end


  private

  def valid_auth?
    return false unless request.headers['HTTP_X_AUTH_ACCOUNT'].present? && request.headers['HTTP_X_AUTH_ID'].present?
    return false unless request.headers['HTTP_X_AUTH_ACCOUNT'].to_s == "unifonic_ledger"
    request.headers['HTTP_X_AUTH_ID'].to_s  == "TU81ee2d6273664d7f9308693122b88a95"
  end

end
