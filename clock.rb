require 'rubygems'
require_relative './lib/louis_vuitton/stock_checker'
require 'clockwork'
require 'active_support/time' # Allow numeric durations (eg: 1.minutes)
require 'httparty'

$logger = Logger.new(STDERR)
$has_notified = false

def check_stock
  in_stock_sku = []

  ENV.slice(
    "DE_SKU_IDS", "DK_SKU_IDS", "LU_SKU_IDS", "BE_SKU_IDS", "IE_SKU_IDS",
    "MC_SKU_IDS", "NL_SKU_IDS", "AT_SKU_IDS", "FI_SKU_IDS", "SE_SKU_IDS",
    "FR_SKU_IDS", "IT_SKU_IDS", "GB_SKU_IDS", "RU_SKU_IDS", "US_SKU_IDS",
    "BR_SKU_IDS", "CA_SKU_IDS", "NZ_SKU_IDS", "MY_SKU_IDS", "SG_SKU_IDS",
    "AU_SKU_IDS", "CN_SKU_IDS", "TW_SKU_IDS", "JP_SKU_IDS", "KR_SKU_IDS",
    "HK_SKU_IDS"
  ).each do |key, sku_ids_string|
    next if sku_ids_string.nil?
    sku_ids = sku_ids_string.split(",")
    country_code = key.split("_")[0]

    stock_level = LouisVuitton::StockChecker.check_stock_for(sku_ids: sku_ids, country_code: country_code)

    sku_ids.each do |sku_id|
      stores = stock_level.fetch(country_code)
      stores.each do |store_lang, sku_details|
        in_stock = !!sku_details.dig(sku_id, "inStock")

        $logger.warn "SKU: #{sku_id}, Country: #{country_code}, Store: #{store_lang}, In Stock: #{in_stock}"

        if in_stock
          in_stock_sku << { sku_id: sku_id, country_code: country_code, store: store_lang }
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
      url = URI::HTTP.build(host: 'localhost', path: '/notify-via-sms')
      begin
        @result = HTTParty.post(@url,
          body: { number: number, content: body }.to_json,
          headers: { 'Content-Type' => 'application/json' })
      rescue HTTParty::Error
        $logger.error "Failed to notify via SMS"
        return nil
      rescue StandardError => e
        $logger.error e.backtrace
        raise
      end
    end

    if email = ENV['NOTIFY_TO_EMAIl']
      $logger.warn "Notify user via email"
      url = URI::HTTP.build(host: 'localhost', path: '/notify-via-email')
      begin
        @result = HTTParty.post(@url,
          body: { email: email, content: body, subject: "LV Stock Check Report #{Time.now}"}.to_json,
          headers: { 'Content-Type' => 'application/json' })
      rescue HTTParty::Error
        $logger.error "Failed to notify via email"
        return nil
      rescue StandardError => e
        $logger.error e.backtrace
        raise
      end
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

  check_stock_frequency_in_seconds = ENV.fetch('STOCK_CHECK_FREQUENCY', 5).to_i.seconds
  notification_clear_frequency_in_seconds = ENV.fetch('NOTIFICATION_CLEAR_FREQUENCY', 7200).to_i.seconds

  every(check_stock_frequency_in_seconds, :check_stock)
  every(notification_clear_frequency_in_seconds, :clear_notified_list)
end
