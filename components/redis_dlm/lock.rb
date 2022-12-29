module RedisDlm
  class Lock
    include RedisDlm::Helpers::RedisHelper

    def initialize(obj:, ttl: nil, lock_for:, content: nil, start_time: nil)
      @obj = obj
      @postfix = lock_for
      @ttl = (ttl || 2.minutes).to_i
      @content = content || SecureRandom.uuid.remove(/\-/)
      @start_time = start_time || Time.now
    end

    def lock
      set_lock && same_content?
    end

    def lock!
      lock || raise(RedisDlm::Error, "Object's been already locked")
    end

    def unlock
      release_lock
    end

    def unlock!
      unlock || raise(RedisDlm::Error, "Couldn't release Lock- Invalid content")
    end

    private

    def get_lock
      redis_get generate_key
    end

    def set_lock
      redis_setnx(key: generate_key, ttl: @ttl, value: lock_body.to_json)
    end

    def release_lock
      lock_content = get_lock
      return if lock_content.blank?
      lock_content = JSON.parse(lock_content)
      return if lock_content['content'] != @content.to_s
      redis_del generate_key
    end

    def same_content?
      body = get_lock
      false if body.blank?

      JSON.parse(body)['content'] == @content.to_s
    end

    def generate_key
      @obj.class.to_s.downcase + '_' + @obj.try(:id).to_s + '_' + @postfix.to_s
    end

    def lock_body
      {
        'ttl' => @ttl,
        'content' => @content,
        'validity_time' => @start_time + @ttl
      }
    end
  end
end
