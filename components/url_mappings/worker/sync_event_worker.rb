require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web'

class UrlMappings::Worker::SyncEventWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(country, user_agent, org_id, old_id, redirect_key)
    history = Histories::HistoryService.new.create(attributes: {url_mapping_id: old_id, country: country, user_agent: user_agent})
    url_mapping = UrlMappings::UrlMappingService.new.filter(criteria: {url_mapping_id: old_id}, with_bulk_request: true).last
    return unless url_mapping
    UrlMappings::UrlMappingService.new.mark_visit(redirect_key: redirect_key) # record link clicks
    if url_mapping.external_ref_id&.start_with?('FLOWSTUDIO:ledger:')
      KafkaWebhook::Service.new.push_flow_studio_event(url_mapping: url_mapping,history: history)
    else
      KafkaWebhook::Service.new.sync_click_event(url_mapping: url_mapping, history: history)  # Adding to Kafka Queue
    end
  rescue => e
    Rails.logger.error(e)
    Rails.logger.error("className: #{self}error in creating bulk url mappings")
  end
end
