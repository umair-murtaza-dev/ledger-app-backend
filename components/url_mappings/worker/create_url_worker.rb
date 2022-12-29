require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/cron/web'

class UrlMappings::Worker::CreateUrlWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(batch)
    UrlMappings::UrlMapping.import batch
  rescue => e
    Rails.logger.error(e)
    Rails.logger.error("className: #{self}error in creating bulk url mappings")
  end
end
