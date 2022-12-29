require 'httpclient'
module Nextgen
  module Sms
    class Transciever
      def initialize
        @connection = Faraday.new(url: url) do |faraday|
          faraday.request :multipart
          faraday.request :url_encoded
          faraday.adapter Faraday.default_adapter
        end
      end

      def send_sms(number:, message:, app_sid:, sender_id:)
        params = {
          :Recipient => number.gsub(/[^a-z,0-9]/, ""),
          :Body => message.encode(Encoding::UTF_8),
          :AppSid => app_sid,
          :SenderID => sender_id,
          :Priority => 'High'
        }
        post(uri: URI("/rest/SMS/Messages/Send"), params: params)
      end

      private

      def post(uri:, params: {})
        response_handler do
          @connection.post do |req|
            req.url uri
            req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
            req.body = params
          end
        end
      end

      def sms_secrets
        Rails.application.credentials.sms || {}
      end

      def url
        sms_secrets&.dig(:base_url)
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
          when 401..401
            return [JSON.parse(response.body), response.status]
          when 401..499
            raise ::Errors::UnresolvableByRepeat.new(status: response.status, body: response.body)
          when 500..599
            raise ::Errors::ResolvableByRepeat.new(status: response.status, body: response.body)
          else
            raise ::Errors::UnresolvableByRepeat.new(status: response.status, body: response.body)
          end
        rescue HTTPClient::ReceiveTimeoutError, HTTPClient::KeepAliveDisconnected, HTTPClient::ConnectTimeoutError, Errno::ECONNREFUSED, Net::ReadTimeout, Faraday::Error => error
          Rails.logger.error("Nextgen sms error: #{error.message}")
          raise ::Errors::ResolvableByRepeat.new(status: response&.status, body: response&.body, default_message: error.message)
        end
      end
    end
  end
end
