require 'msgpack'


class BulkRequests::Worker::CreateTinyUrlWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, profile:true

  def perform(bulk_request_id, index, long_url, user_id, allowed_hits, host_url, custom_domain_id, created_at, redirect_key_length, marshall_key, created_at_unix)
    begin
      redis = Redis.new(url: ENV['ledger_locker_redis_uri'])
      chunk_json = MessagePack.unpack(redis.get(marshall_key))
      batch = []
      columns = [:user_id, :title, :host_url, :redirect_key, :redirect_link, :allowed_hits, :remaining_hits, :uuid, :bulk_request_id, :ref_id, :custom_domain_id, :mapping_tags, :external_ref_id, :created_at_unix]
      chunk_json.each do |tiny_link|
        if !tiny_link["phone_number"].present?
          next
        end
        batch << [ user_id, tiny_link["phone_number"], host_url, generate_redirect_key(redirect_key_length), tiny_link["long_url"].present? ? tiny_link["long_url"] : long_url, allowed_hits, allowed_hits, MySQLBinUUID::Type.new.cast(SecureRandom.uuid.encode(Encoding::ASCII_8BIT)), bulk_request_id, nil, custom_domain_id, tiny_link["tags"],nil, created_at_unix]
      end
      chunk_json = nil
      UrlMappings::UrlMapping.import columns, batch
      redis.decr("campaign_#{bulk_request_id}_count") # decrement worker count into redis
      redis.del(marshall_key)
      BulkRequests::Worker::CreateCsvWorker.perform_async(bulk_request_id) if redis.get("campaign_#{bulk_request_id}_count").to_i == 0
    rescue ActiveRecord::RecordInvalid => e
      redis.decr("campaign_#{bulk_request_id}_count") # decrement worker count into redis
      Rails.logger.error(e)
      Rails.logger.error("className: #{self}, record_invalid tiny_url, bulk_request_id: #{bulk_request_id}")
    rescue StandardError => e
      redis.decr("campaign_#{bulk_request_id}_count") # decrement worker count into redis
      Rails.logger.error(e)
      Rails.logger.error("className: #{self}, Standard Error tiny_url, bulk_request_id: #{bulk_request_id}")
    rescue => e
      Rails.logger.error(e)
      Rails.logger.error("classNamassae: #{self}, redis error : #{bulk_request_id}, index : #{index}")
    end
  end

  def generate_redirect_key(redirect_key_length)
    SecureRandom.hex(redirect_key_length)
  end
end
