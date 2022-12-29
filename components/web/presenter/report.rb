class Web::Presenter::Report
  include Common::Helpers::TranslationHelper
  def initialize(dto:)
    @dto = dto
  end

  def present
    {
      no_of_clicks: 12356,
      countries: ["pakistan", "United Arab Emirates"],
      device_types: ["IOS", "Android", "Chrome"]
    }
  end
end
