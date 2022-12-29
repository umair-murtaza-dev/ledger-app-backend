class ReportMailer < ApplicationMailer
  default from: 'admin@unifonic.com'

  # ReportMailer.send_csv
  def send_csv(report_id)
    @report = Reports::Report.find(report_id)
    mail(to: @report.bulk_request&.email, subject: 'Report CSV of Tiny URLs')
  end
end
