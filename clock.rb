require 'rubygems'
require_relative './lib/louis_vuitton/stock_checker'
require_relative './lib/email_notifier'
require_relative './lib/sms_notifier'
require 'clockwork'
require 'active_support/time' # Allow numeric durations (eg: 1.minutes)

SKU_IDS=ENV.fetch('SKU_IDS').split(',')
COUNTRIES=ENV.fetch('COUNTRIES').split(',')

$logger = Logger.new(STDERR)
$has_notified = false

def check_stock
  in_stock_sku = []

  COUNTRIES.each do |country_code|
    stock_level = LouisVuitton::StockChecker.check_stock_for(sku_ids: SKU_IDS, country_code: country_code)

    SKU_IDS.each do |sku_id|
      stores = stock_level.fetch(country_code)
      stores.each do |store_lang, sku_details|
        in_stock = !!sku_details.dig(sku_id, "inStock")

        $logger.warn "SKU: #{sku_id}, Country: #{country_code}, Store: #{store_lang}, In Stock: #{in_stock}"

        if in_stock
          in_stock_sku << { sku: sku_id, country: country_code, store: store_lang }
        end
      end
    end
  end

  if in_stock_sku.any? && !$has_notified
    body = in_stock_sku.map do |sku|
      "SKU: #{sku[:sku_id]}, Country: #{sku[:country_code]}, Store: #{sku[:store]}, In Stock: true"
    end.join("\n")

    if number = ENV['TWILIO_RECEIVER_PHONE_NUMBER']
      $logger.warn "Notify user via SMS"
      SmsNotifier.perform(to: number, body: body)
    end

    if email = ENV['NOTIFY_TO_EMAIl']
      $logger.warn "Notify user via email"
      EmailNotifier.perform(email: email, subject: "LV Stock Check Report #{Time.now}", body: body)
    end

    $has_notified = true
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
      $has_notified = false
    end
  end

  check_stock_frequency = ENV.fetch('STOCK_CHECK_FREQUENCY', 5).to_i.seconds
  notification_clear_frequency = ENV.fetch('NOTIFICATION_CLEAR_FREQUENCY', 7200).to_i.seconds

  every(check_stock_frequency, :check_stock)
  every(notification_clear_frequency, :clear_notified_list)
end
