require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'csv'

class Reports::Worker::CreateCsvWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(report_id)
    report = Reports::Report.find(report_id)
    return unless report

    file_name =  "report_#{Date.today.to_time.to_i}.csv"
    headers = ['Reference Number', 'Short URL' , 'Variable', 'Click', 'Click At', 'Tags', 'Long URL']
    CSV.open(file_name, 'w', write_headers: true, headers: headers) do |csv|
      report.bulk_request.url_mappings.includes(:histories).find_each(batch_size: 5000) do |mapping|
        csv << [mapping.title,
                "#{mapping.host_url}#{mapping.redirect_key}",
                mapping.redirect_key,
                mapping.allowed_hits.to_i - mapping.remaining_hits.to_i,
                mapping.histories&.last&.created_at,
                mapping.mapping_tags,
                mapping.redirect_link
        ]
      end
    end
    file_path = "#{ENV['ledger_aws_prefix']}#{report.user_id}/#{file_name}"
    csv_link = Common::S3Service.new.file_upload(file_name, file_path, file_name)
    report.report_link = csv_link
    report.completed!

    ReportMailer.send_csv(report.id).deliver_now # Sending ledger report csv email
    File.delete(file_name)
  rescue => e
    report.failed!
    Rails.logger.error(e)
    Rails.logger.error("report_id: #{report.id}, error in creating and uploading tiny url report csv")
  end
end
