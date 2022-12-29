class Sso::Api::V1::SettingsController < Sso::Api::V1::ApplicationController
  skip_before_action :authenticate!
  def index
    render json: UnifonicCloud::Auth::Service.new.settings
  end
end
