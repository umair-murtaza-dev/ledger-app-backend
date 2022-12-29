# Redis Distributed Lock Manager
# https://redis.io/topics/distlock
module RedisDlm
  module Dlm
    def self.with_lock!(obj:, ttl: 2.minutes, lock_for: 'general', &block)
      lock = RedisDlm::Lock.new(obj: obj, ttl: ttl, lock_for: lock_for)
      lock.lock!
      begin
        block.call(lock)
      ensure
        lock.unlock
      end
    end
  end
end
