require 'httpclient'
class Nextgen::Transciever

  def initialize
    @connection = Faraday.new(url: url)
  end

  def country(code:)
    countries.detect {|c| c['Cc'].to_s == code.to_s}
  end

  def countries(limit: 10000)
    response, response_code = post(function: 'provisioning/GetCountry', params: {"Limit": limit})
    response&.dig("Data", "Country") || []
  end

  def get_all_sender_ids(account_id:, limit: 1000, params: {}, offset: 0)
    params.merge!({
      "Limit": limit,
      "Offset": offset,
      "AccountUUID": account_id,
      "ResourceType": 'all',
    })
    response, response_code = post(function: 'provisioning/GetSenderID', params: params)
    response&.dig("Data", "SenderIDs") || []
    # [{'SenderName' => '1st Sender Name'}, {'SenderName' => 'Last Sender Name'}]
  end

  def app_sid(account_id:, limit: 1000, params: {}, offset: 0)
    params.merge!({"Limit": limit, "AccountUUID": account_id, "Type": "HTTP"})
    response, response_code = post(function: 'provisioning/GetAppSid', params: params)
    response&.dig("Data", "AppSids", "List") || []
    # [{"ID" => "1",  "Name" => "Adnan Munir", "AppSid" => "12", "UUID" => "1"}, {"ID" => "2", "Name" => "Aftab Baig", "AppSid" => "13", "UUID" => "2"}, {"ID" => "3", "Name" => "Umair Murtaza 1", "AppSid" => "14", "UUID" => "3"}, {"ID" => "4", "Name" => "Talha Shoaib 5", "AppSid" => "15", "UUID"=> "4"}]
  end

  def accounts(limit: 1000, params: {}, offset: 0)
    params.merge!({"Limit": limit, "Type": "HTTP"})
    response, response_code = post(function: 'provisioning/GetAccount', params: params)
    response&.dig("Data", "Accounts") || []
    # [{"UUID" => "096dbece-f82e-11e8-809b-0252151e4411", "AccountName" => "Adnan Munir"}, {"UUID" => "096dbece-f82e-11e8-809b-0252151e4411", "AccountName" => "Aftab Baig"}, {"UUID" => "096dbece-f82e-11e8-809b-0252151e4411", "AccountName" => "Umair Murtaza 1"}, {"UUID" => "096dbece-f82e-11e8-809b-0252151e4411", "AccountName" => "Talha Shoaib 5"}]
  end

  def enabled?
    !!(ENV['ledger_nextgen_enabled'])
  end

  private

  def secret
    ENV['ledger_nextgen_secret_key']
  end

  def url
    ENV['ledger_nextgen_base_url']
  end

  def get(function:)
    response_handler { @connection.get(function) }
  end

  def patch(function:, params: {})
      response_handler { @connection.patch(function, params.merge({"SecretKey": secret})) }
  end

  def post(function:, params: {})
    response_handler { @connection.post(function, params.merge({"SecretKey": secret})) }
  end

  def response_handler
    response = nil
    begin
      response = yield
      case response.status
      when 200..299
        return [JSON.parse(response.body), response.status]
      when 422..422
        return [JSON.parse(response.body), response.status]
      when 300..399
        return [{}, response.status]
      when 400..400
        return [JSON.parse(response.body), response.status]
      when 401..499
        raise ::Errors::UnresolvableByRepeat.new(status: response.status, body: response.body)
      when 500..599
        raise ::Errors::ResolvableByRepeat.new(status: response.status, body: response.body)
      else
        raise ::Errors::UnresolvableByRepeat.new(status: response.status, body: response.body)
      end
    rescue HTTPClient::ReceiveTimeoutError, HTTPClient::KeepAliveDisconnected, HTTPClient::ConnectTimeoutError, Errno::ECONNREFUSED, Net::ReadTimeout, Faraday::Error => error
      Rails.logger.error("Nextgen error: #{error.message}")
      raise ::Errors::ResolvableByRepeat.new(status: response&.status, body: response&.body, default_message: error.message)
    end
  end

end
