class Web::Presenter::BulkReqReport
  include Common::Helpers::TranslationHelper
  def initialize(report:)
    @report = report
  end

  def present
    {
      title: @report.title,
      links_count: @report.links_count,
      status: @report.status,
      duration: @report.duration,
    }
  end
end
