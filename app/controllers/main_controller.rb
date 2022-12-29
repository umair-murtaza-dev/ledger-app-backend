class MainController < ApplicationController
  def status
    statuses = prepare_statuses
    unless statuses[:dependecies].values.all?
      Rails.logger.info statuses
      return render json: statuses, status: :service_unavailable
    end
    render json: statuses, status: :ok
  end

  def web_server_status
    render plain: 'Web server is available and healthy!', status: :ok
  end

  def redirector
    # log and redirect
    url = UrlMappings::UrlMappingService.new.fetch_by_redirect_key(redirect_key: params[:id])
    return if url.blank? || !url.allowed_to_hit
    country = ip_location
    user_agent = request.user_agent
    UrlMappings::Worker::SyncEventWorker.perform_async(country, user_agent, url.org_id, url.old_id, params[:id])
    redirect_to url.redirect_link
  end

  def zipkin
    headers = request.headers
    Rails.logger.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    Rails.logger.info("Zipkin header: #{headers.inspect}")
    Rails.logger.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")

    render json: {}, status: :ok
  end

  def sidekiq_logs
    stats = Sidekiq::Stats.new
    resp ={
      "component":"sideqik",
      "processed": stats.processed,
      "failed": stats.failed,
      "scheduled_size": stats.scheduled_size,
      "retry_size": stats.retry_size,
      "dead_size": stats.dead_size,
      "processes_size": stats.processes_size,
      "default_queue_latency": stats.default_queue_latency,
      "workers_size": stats.workers_size,
      "queued": stats.enqueued
    }

    render json: resp, status: :ok
  end

  def health
    statuses = prepare_statuses
    resp = {
      "status": statuses[:dependecies].values.all? ? "UP" : "DOWN",
      "environment": Rails.env,
      "host": `hostname`.chop,
      "details": {
        "database": {
          "status": statuses[:dependecies][:databsae] ? "UP" : "DOWN",
          "details": {
            "database": "Mysql",
            "query": "SELECT 1"
          }
        },
        "SidekiqRedis": {
          "status": statuses[:dependecies][:sidekiq_redis] ? "UP" : "DOWN",
          "details": {
            "query": "test_status get and set in Redis",
          }
        },
        "LockerRedis": {
          "status": statuses[:dependecies][:locker_redis] ? "UP" : "DOWN",
          "details": {
            "query": "Lock obj in Redis and check pool size",
          }
        }
      }
    }
    if resp[:status] != "UP"
      Rails.logger.info resp
      return render json: resp, status: :service_unavailable
    end
    render json: resp, status: :ok
  end

  private

  def prepare_statuses
    {
      dependecies: {
        databsae: db_is_okay?,
        locker_redis: locker_redis_is_okay?
      },
      status: 'working',
      vault_credentials: ENV['ledger_testing_secret'] || 'unsuccessful',
      environment: Rails.env,
      host: `hostname`.chop
    }
  end

  def db_is_okay?
    return ActiveRecord::Base.connection.query('select 1;') == [[1]]
  rescue => _
    return false
  end

  def locker_redis_is_okay?
    redis_pool = RedisDlm::Lock.new(obj: nil, lock_for: nil).connection
    redis_is_okay?(redis_pool: redis_pool)
  end

  def redis_is_okay?(redis_pool:)
    "OK" == redis_pool.with{|conn| conn.set("test_status", "OK")} && "OK" == redis_pool.with{|conn| conn.get("test_status")}
  rescue => _
    return false
  end


  def browser_stats
      @browser ||= Browser.new( request.headers["User-Agent"], accept_language: request.headers["Accept-Language"] )
  end


  def ip_location
    db = MaxMindDB.new('./GeoLite2-City.mmdb')
    Rails.logger.error("Forwarded IP --- #{request.headers['X-Forwarded-For']} --- connecting IP #{request.headers['CF-Connecting-IP']}")
    ret = db.lookup(request.headers['CF-Connecting-IP']) # Whilt in localhost this wont won't work. So change request.remote_ip with your actual IP address to test.
    ret.present? && ret&.city&.name.present? ? "#{ret.city.name}, #{ret.country.name}" : ret&.country&.name.present? ? "#{ret.country.name}" : nil
  end

  def get_ip
    request.remote_ip
  end
end
