class Sso::Api::V1::ApplicationController < ActionController::API
  include Sso::Api::V1::AuthenticationHelper
  include Common::Helpers::ExceptionHandlerHelper
  include Common::Helpers::PageMetaHelper
  include ActionController::Caching

  before_action :authenticate!
  before_action :prepare_exception_notifier
  before_action :set_format
  before_action :set_locale

  def set_format
    request.format = :json
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

  def module_type
    params[:module_type]
  end
end
