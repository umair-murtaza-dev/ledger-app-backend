class Common::Helpers::Authenticator
  def initialize(secret:)
    @secret = secret
  end

  def authenticate(token:)
    if token.present?
      begin
         JWT.decode(token, @secret)
      rescue => e
        return
      end
    else
      return
    end
  end

  def generate_token(payload: {}, time: (Time.now + 2.hours).to_i)
    payload.merge!({exp: time}) if time
    token = JWT.encode payload, @secret
    return token
  end

  def valid_app?(app:, token:)
    data = authenticate(token: token)
    return unless data
    app.service_id == (data.first || {})['account_id']
  end

  def generate_app_token(account_id:)
    generate_token(payload: {account_id: account_id}, time: nil)
  end
end
