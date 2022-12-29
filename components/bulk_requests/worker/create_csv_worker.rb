require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'csv'

class BulkRequests::Worker::CreateCsvWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(bulk_request_id)
    Rails.logger.debug(">>>>>>> In preparing CSV worker")
    return BulkRequests::Worker::CreateCsvWorker.perform_in(30.seconds, bulk_request_id) unless Redis.new(url: ENV['ledger_locker_redis_uri']).get("campaign_#{bulk_request_id}_count").to_i == 0
    Rails.logger.debug(">>>>>>> File preparing started")
    bulk_request = BulkRequests::BulkRequest.find(bulk_request_id)
    return unless bulk_request
    bulk_request.complete!
    external_ref_id = bulk_request.external_ref_id
    file_name =  "#{external_ref_id}_#{Date.today.to_time.to_i}.csv"
    headers = ['Reference Number', 'Campaign ID', 'Short URL','Click', 'Location', 'Tags', 'Long URL', 'Variable']

    CSV.open(file_name, 'w', write_headers: true, headers: headers, encoding: Encoding::UTF_8) do |csv|
      UrlMappings::UrlMapping.includes(:bulk_request).where(bulk_request_id: bulk_request_id).find_each(batch_size: ENV.fetch("batch_size")&.to_i || 500) do |mapping|
        csv << [mapping.title,
                external_ref_id,
                "#{mapping.host_url}#{mapping.redirect_key}",
                mapping.allowed_hits.to_i - mapping.remaining_hits.to_i,
                '',
                mapping.mapping_tags,
                mapping.redirect_link,
                mapping.redirect_key
        ]
      end
    end
    Rails.logger.debug(">>>>>>> CSV ready for S3 upload")
    file_path = "#{ENV['ledger_aws_prefix']}#{bulk_request.user_id}/#{file_name}"
    csv_link = Common::S3Service.new.file_upload(file_name, file_path, file_name)
    bulk_request.file_name = file_name
    bulk_request.csv_link = csv_link
    bulk_request.csv_status = 'completed'
    bulk_request.save!
    Rails.logger.debug(">>>>>>> CSV uploaded to S3")
    BulkRequestMailer.send_csv(bulk_request.id).deliver_now if bulk_request.email.present? # Sending ledger csv email
    KafkaWebhook::Service.new.sync_event(bulk_request: bulk_request) # Adding to Kafka Queue
    File.delete(file_name)
  rescue => e

    bulk_request.failed!
    Rails.logger.error(e)
    Rails.logger.error("className: #{self},bulk_request_id: #{bulk_request.id}, error in creating and uploading tiny url csv -- retrying")
    BulkRequests::Worker::CreateCsvWorker.perform_async(bulk_request_id)
  end
end
