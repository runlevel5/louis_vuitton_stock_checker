require 'sendgrid-ruby'
include SendGrid

class EmailNotifier
  attr_reader :email, :subject, :body

  def initialize(email:, subject:, body:)
    @email = email
    @subject = subject
    @body = body
  end

  def perform
    mail = Mail.new(from, subject, to, content)
    sendgrid_client.client.mail._('send').post(request_body: mail.to_json)
  end

  def self.perform(email:, subject:, body:)
    self.new(email: email, subject: subject, body: body).perform
  end

  private

  def from
    @from ||= Email.new(email: 'no-reply@lv-addict.io')
  end

  def to
    @to ||= Email.new(email: email)
  end

  def content
    @content ||= Content.new(type: 'text/plain', value: body)
  end

  def sendgrid_client
    @sendgrid_client ||= SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  end
end

