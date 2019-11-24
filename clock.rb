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
$has_notified_list = {}

def notify_via_sms(body:)
  $client.messages.create(
    from: ENV.fetch('TWILIO_SENDER_PHONE_NUMBER'),
    to: ENV.fetch('TWILIO_RECEIVER_PHONE_NUMBER'),
    body: body)
end

def check_stock
  COUNTRIES.each do |country_code|
    stock_level = LouisVuitton::StockChecker.check_stock_for(sku_ids: SKU_IDS, country_code: country_code)

    SKU_IDS.each do |sku_id|
      stores = stock_level.fetch(country_code)
      stores.each do |store_lang, sku_details|
        if in_stock = !!sku_details.dig(sku_id, "inStock")
          $logger.warn "SKU: #{sku_id}, Country: #{country_code}, Store: #{store_lang}, In Stock: #{in_stock}"

          if $has_notified_list["#{sku_id}__#{store_lang}"].nil?
            $logger.warn "Notify user via SMS"
            notify_via_sms(body: "SKU: #{sku_id}, Country: #{country_code}, Store: #{store_lang}, In Stock: #{in_stock}")
            $has_notified_list["#{sku_id}__#{store_lang}"] = true
          end
        end
      end
    end
  end


end

module Clockwork
  configure do |config|
    config[:logger] = $logger
  end

  handler do |command, time|
    case command
    when :check_stock
      check_stock
    when :clear_notified_list
      $has_notified_list = {}
    end
  end

  every(5.seconds, :check_stock)
  every(30.minutes, :clear_notified_list)
end
