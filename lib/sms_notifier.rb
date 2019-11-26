require 'twilio-ruby'

class SmsNotifier
  attr_reader :to, :body

  def initialize(to:, body:)
    @to = to
    @body = body
  end

  def perform
    twilio_client.messages.create(
      from: from,
      to: to
      body: body)
  end

  def self.perform(to:, body:)
    self.new(to: to, body: body).perform
  end

  private

  def from
    @from ||= ENV.fetch('TWILIO_SENDER_PHONE_NUMBER')
  end

  def twilio_client
    @twilio_client = Twilio::REST::Client.new ENV.fetch('TWILIO_ACCOUNT_SID'), ENV.fetch('TWILIO_AUTH_TOKEN')
  end
end

