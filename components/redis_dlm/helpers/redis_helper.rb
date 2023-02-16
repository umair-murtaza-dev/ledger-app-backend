require 'redis-namespace'

module RedisDlm
  module Helpers
    module RedisHelper
      def redis_setex(key:, ttl:, value:)
        connection.with do |conn|
          conn.setex(key, ttl, value)
        end
      end

      def redis_get(key)
        connection.with do |conn|
          conn.get key.to_s
        end
      end

      def redis_del(key)
        connection.with do |conn|
          conn.del key.to_s
        end
      end

      def redis_setnx(key:, value:, ttl: nil)
        connection.with do |conn|
          settings = [:set, key, value, :nx]
          settings += [:ex, ttl] if ttl&.positive?
          if conn.call(settings)
            return true
          end
        end
        false
      end

      def connection
        @@connection ||= ConnectionPool::Wrapper.new(size: 5, timeout: 5) do
          redis = Redis.new(url: ENV['ulink_locker_redis_uri'])
          redis
        end
      end
    end
  end
end
