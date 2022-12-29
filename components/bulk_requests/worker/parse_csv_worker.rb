require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web'
require 'smarter_csv'
require 'msgpack'
class BulkRequests::Worker::ParseCsvWorker
  include Sidekiq::Worker
  sidekiq_options retry: false


  def perform(bulk_request_id)
    bulk_request = BulkRequests::BulkRequest.find(bulk_request_id)
    return unless bulk_request

    #set bulk request worker count in redis
    redis = Redis.new(url: ENV['ledger_locker_redis_uri'])
    redis.set("campaign_#{bulk_request.id}_count", 0)
    file_path = ActiveStorage::Blob.service.path_for(bulk_request.file.key)
    host_url = bulk_request.custom_domain_id ? fetch_custom_domain(bulk_request.custom_domain_id) : fetch_host_url
    host_url = host_url.last.eql?('/') ? host_url : (host_url + '/')
    allowed_hits = get_allowed_hits
    redirect_key_length = ENV['ledger_redirect_key_length'].to_i
    index = 0
    SmarterCSV.process(file_path, {chunk_size: ENV.fetch("batch_size") || 500, force_utf8: true, file_encoding: 'iso-8859-1|utf-8'}) do |chunk|
      Rails.logger.debug("<<<<<<<<<<<<    <<<<<<<< #{chunk.size}")
      marshall_key = "marshal_#{bulk_request_id}_#{index}"
      redis.set(marshall_key, MessagePack.pack(chunk))
      redis.incr("campaign_#{bulk_request_id}_count") # increment worker count into redis
      Rails.logger.debug("<<<<<<<<<<<<    <<<<REDIS SET<<<< #{chunk.size}")
      BulkRequests::Worker::CreateTinyUrlWorker.perform_async(bulk_request_id, index, bulk_request.long_url, bulk_request.user_id, allowed_hits, host_url, bulk_request.custom_domain_id, bulk_request.created_at, redirect_key_length, marshall_key, DateTime.current.to_i)
      index+=1
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error(e)
      Rails.logger.error("className: #{self}, bulk_request_id: #{bulk_request_id}")
      retry
    rescue => e
      Rails.logger.error(e)
      Rails.logger.error("className: #{self}, bulk_request_id: #{bulk_request_id}")
      next
    end

    bulk_request.in_progress!
    # BulkRequests::Worker::CreateCsvWorker.perform_async(bulk_request_id)
  end

  def get_allowed_hits
    999999
  end

  def fetch_host_url
    ENV['ledger_host_url']
  end

  def fetch_custom_domain(custom_domain_id)
    custom_domain = CustomDomains::CustomDomain.find_by(id: custom_domain_id)
    return fetch_host_url unless custom_domain
    custom_domain.host
  end
end
