class Api::V1::ApplicationController < ActionController::API
  before_action :authenticate_user!
  before_action :set_company

  def set_company
    @current_company = current_user.company
  end

  def current_company
    @current_company
  end
end
