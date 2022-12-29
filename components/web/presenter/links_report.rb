class Web::Presenter::LinksReport
  def initialize(report:)
    @report = report
  end

  def present
    {
      date: @report.date,
      links_count: @report.links_count
    }
  end
end
