# frozen_string_literal: true

require 'sidekiq'

module Sidekiq
  # Sidekiq::Logging
  module Logging
    def self.job_hash_context(job_hash)
      klass = job_hash['wrapped'] || job_hash['class']
      bid = job_hash['bid']
      args = job_hash['args']
      "#{klass} ARGS-#{args} JID-#{job_hash['jid']} BID-#{bid}"
    end
  end
end

Encoding.default_external = Encoding::UTF_8

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['redis_cache_uri'], id: nil }
  schedule_file = "#{Rails.root}/config/schedule.yml.erb"

  if File.exist?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.safe_load(ERB.new(File.read(schedule_file)).result)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['redis_cache_uri'], id: nil }
end
