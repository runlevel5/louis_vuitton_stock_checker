require 'rubygems'
require 'sinatra'
require_relative './lib/email_notifier'
require_relative './lib/sms_notifier'

post '/notify-via-email' do
  EmailNotifier.perform(email: params[:email], subject: params[:subject], body: params[:content])
end

post '/notify-via-sms' do
  SmsNotifier.perform(to: params[:number], body: params[:content])
end