class Errors::Error < StandardError
  def initialize(status: nil, body: nil, default_message: nil)
    @status = status
    @body = body
    @default_message = default_message
  end

  def to_s
    "MESSAGE: #{@default_message}, STATUS: #{@status}, => BODY: #{@body}"
  end

  def message
    to_s
  end
end
