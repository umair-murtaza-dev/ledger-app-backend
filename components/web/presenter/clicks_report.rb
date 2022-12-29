class Web::Presenter::ClicksReport
  include Common::Helpers::TranslationHelper
  def initialize(report:)
    @report = report
  end

  def present
    {
      date: @report.date,
      clicks_count: @report.clicks_count
    }
  end
end
