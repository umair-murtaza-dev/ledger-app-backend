Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.base_controller_class = ['ActionController::API', 'ActionController::Base']
  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format id)
    {
      params: event.payload[:params].except(*exceptions)
    }
  end

  config.lograge.custom_payload do |controller|
    {
      user_id: controller.respond_to?(:current_user) ? controller.current_user.try(:id) : nil,
      email: controller.respond_to?(:current_user) ? controller.current_user.try(:email) : nil,
      app_id: controller.respond_to?(:current_app) ? controller.current_app.try(:service_id) : nil
    }
  end
end
