class KafkaWebhook::Service

  def initialize
    @kafka = Kafka.new(get_kafka_url)
    @fs_kafka = Kafka.new(get_fs_kafka_url)
  end

  def sync_event(bulk_request:, account_id: nil)
    begin
      account_id ||= Users::User.find(bulk_request.user_id)&.account_id
      data = {
        "eventid": bulk_request.bulkurl_ref_id,
        "eventtype": "unifonic_ledger.bulk_request_process",
        "account.id": "#{account_id}",
        "version": "v1",
        "timestamp": "#{bulk_request.updated_at&.utc&.iso8601}",
        "priority": "2",
        "loglevel": "1",
        "data": { "bulkurl_ref_id": "#{bulk_request.bulkurl_ref_id}", "csv_link": "#{bulk_request.csv_link}" },
      }
      producer = @kafka.producer
      producer.produce(data.to_json, topic: ready_topic_name)
      producer.deliver_messages
    rescue => e
      message_error = e.message
      Rails.logger.error("className: #{self}, error in syncing event with Kafka: #{message_error}")
    end
  end

  def sync_click_event(url_mapping:, account_id: nil, history:)
    begin
      # url_mapping = UrlMappings::UrlMapping.find_by(id: url_mapping_id)
      account_id ||= Users::User.find(url_mapping.user_id)&.account_id
      data = {
        "eventid": url_mapping.uuid,
        "eventtype": "unifonic_ledger.click",
        "account.id": "#{account_id}",
        "version": "v1",
        "timestamp": "#{url_mapping.updated_at.utc.iso8601}",
        "priority": "2",
        "loglevel": "1",
        "data": {
          "click": "#{url_mapping.allowed_hits.to_i - url_mapping.remaining_hits.to_i}",
          "clickTime": "#{history.created_at&.utc&.iso8601 || DateTime.current.utc.iso8601}",
          "reference": url_mapping.title,
          "tags": url_mapping.tags.present? ? url_mapping.tags.split(",") : [],
          "bulk_request_id": "#{url_mapping.bulk_request&.id}",
          "url_mapping_id": "#{url_mapping.uuid}",
          "timestamp": "#{url_mapping.updated_at&.utc&.iso8601}",
          "redirect_key": "#{url_mapping.redirect_key}",
          "location": "#{url_mapping.locations&.last}",
        },
      }

      producer = @kafka.producer
      producer.produce(data.to_json, topic: click_topic_name)
      producer.deliver_messages
    rescue => e
      message_error = e.message
      Rails.logger.error("className: #{self}, error in syncing event with Kafka: #{message_error}")
    end
  end

  def push_flow_studio_event(url_mapping:, account_id: nil, history:)
    begin
      # url_mapping = UrlMappings::UrlMapping.find_by(id: url_mapping_id)
      account_id ||= Users::User.find(url_mapping.user_id)&.account_id
      data = {
        "eventid": url_mapping.uuid,
        "eventtype": "unifonic_ledger.click",
        "account.id": "#{account_id}",
        "version": "v1",
        "timestamp": "#{url_mapping.updated_at.utc.iso8601}",
        "priority": "2",
        "loglevel": "1",
        "data": {
          "click": "#{url_mapping.allowed_hits.to_i - url_mapping.remaining_hits.to_i}",
          "clickTime": "#{history.created_at&.utc&.iso8601 || DateTime.current.utc.iso8601}",
          "reference": url_mapping.title,
          "referenceId": url_mapping.external_ref_id,
          "tags": url_mapping.tags.present? ? url_mapping.tags.split(",") : [],
          "url_mapping_id": "#{url_mapping.uuid}",
          "timestamp": "#{url_mapping.updated_at&.utc&.iso8601}",
          "redirect_key": "#{url_mapping.redirect_key}",
          "location": "#{UrlMappings::UrlMappingService.new.fetch_locations(mapping: url_mapping).last}",
        },
      }

      producer = @fs_kafka.producer
      producer.produce(data.to_json, topic: fs_topic_name)
      producer.deliver_messages
    rescue => e
      message_error = e.message
      Rails.logger.error("className: #{self}, error in syncing event with Kafka: #{message_error}")
    end
  end

  private

  def click_topic_name
    ENV['ledger_kafka_click_topic_name']
  end

  def fs_topic_name
    ENV['ledger_kafka_flow_studio_topic_name']
  end

  def ready_topic_name
    ENV['ledger_kafka_ready_topic_name']
  end

  def get_kafka_url
    ENV['ledger_kafka_url']
  end

  def get_fs_kafka_url
    ENV['ledger_fs_kafka_url']
  end
end
