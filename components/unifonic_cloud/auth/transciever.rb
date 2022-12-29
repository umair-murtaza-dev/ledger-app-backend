require 'httpclient'
class UnifonicCloud::Auth::Transciever

  def initialize(token: nil, url: nil, response_json: true)
    @url = url || ENV['ledger_unifonic_cloud_base_url']
    @connection = Faraday.new(url: @url) do |faraday|
      faraday.response :logger
      faraday.headers['Content-Type'] = response_json ? 'application/json' : 'text/html'
      faraday.headers['Authorization'] = get_bearer_token(token) if token.present?
      faraday.headers['Accept'] = response_json ? 'application/json' : 'text/html'
      faraday.adapter  Faraday.default_adapter
    end
  end

  def me
    get(function: 'api/v2/user/me')
  end

  def top_bar
    get(function: 'api/navigation/top-bar', response_json: false)
  end


  def token(params:)
    post(function: 'oauth/v2/token', params: params)
  end

  private

  def get_bearer_token(token)
    "Bearer #{token}"
  end

  def get(function:, response_json: true)
    url = "#{@url}/#{function}"
    response_handler(response_json: response_json) { @connection.get(url) }
  end

  def patch(function:, params: {}, response_json: true)
    url = "#{@url}/#{function}"
    response_handler(response_json: response_json) { @connection.patch(url, params.to_json) }
  end

  def post(function:, params: {}, response_json: true)
    url = "#{@url}/#{function}"
    response_handler(response_json: response_json) { @connection.post(url, params.to_json) }
  end

  def response_handler(response_json: true)
    response = nil
    begin
      response = yield
      case response.status
      when 200..299
        return [(response_json ? JSON.parse(response.body) : response.body), response.status]
      when 300..399
        return [{}, response.status]
      when 400, 401, 422
        Rails.logger.error("400-ERROR : #{JSON.parse(response.body)}")
        return [(response_json ? JSON.parse(response.body) : response.body), response.status]
      when 400..499
        Rails.logger.error("400-499-ERROR : #{JSON.parse(response.body)}")
        raise ::Errors::UnresolvableByRepeat.new(status: response.status, body: response.body)
      when 500..599
        raise ::Errors::ResolvableByRepeat.new(status: response.status, body: response.body)
      else
        raise ::Errors::UnresolvableByRepeat.new(status: response.status, body: response.body)
      end
    rescue HTTPClient::ReceiveTimeoutError, HTTPClient::KeepAliveDisconnected, HTTPClient::ConnectTimeoutError, Errno::ECONNREFUSED, Net::ReadTimeout, Faraday::Error => error
      Rails.logger.error("Unifonic cloud error: #{error.message}")
      raise ::Errors::ResolvableByRepeat.new(status: response&.status, body: response&.body, default_message: error.message)
    end
  end

end
