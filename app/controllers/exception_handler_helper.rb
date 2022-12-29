module Common::Helpers::ExceptionHandlerHelper
  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      current_user: self.respond_to?(:current_user) ? current_user : nil,
      current_app: self.respond_to?(:current_app) ? current_app : nil
    }
  end
end
