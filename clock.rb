require 'rubygems'
require_relative './lib/louis_vuitton/stock_checker'
require 'clockwork'
require 'active_support/time' # Allow numeric durations (eg: 1.minutes)
require 'twilio-ruby'

SKU_IDS=ENV.fetch('SKU_IDS').split(',')
COUNTRIES=ENV.fetch('COUNTRIES').split(',')

$logger = Logger.new(STDERR)
account_sid = ENV.fetch('TWILIO_ACCOUNT_SID')
auth_token = ENV.fetch('TWILIO_AUTH_TOKEN')
$client = Twilio::REST::Client.new account_sid, auth_token

def notify_via_sms(body:)
  $client.messages.create(
    from: ENV.fetch('TWILIO_SENDER_PHONE_NUMBER'),
    to: ENV.fetch('TWILIO_RECEIVER_PHONE_NUMBER'),
    body: body)
end

module Clockwork
  configure do |config|
    config[:logger] = $logger
  end

  handler do |_, time|
    COUNTRIES.each do |country_code|
      stock_level = LouisVuitton::StockChecker.check_stock_for(sku_ids: SKU_IDS, country_code: country_code)

      SKU_IDS.each do |sku_id|
        stores = stock_level.fetch(country_code)
        stores.each do |store_lang, sku_details|
          if in_stock = !!sku_details.dig(sku_id, "inStock")
            $logger.warn "SKU: #{sku_id}, Country: #{country_code}, Store: #{store_lang}, In Stock: #{in_stock}"

            notify_via_sms(body: "SKU: #{sku_id}, Country: #{country_code}, Store: #{store_lang}, In Stock: #{in_stock}")
          end
        end
      end
    end
  end

  every(30.seconds, "Checking stock. SKUs: #{SKU_IDS}, Stores: #{COUNTRIES}")
end
