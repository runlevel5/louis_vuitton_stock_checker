## Louis Vuitton Stock Level Check

Instead of sitting in front of your browser pressing F5 now and then to see if a particular item is in stock or not. It is now much easier to use this app to periodically check for you. If items are avaialble, it would notify you via SMS.

## Setup

`bundle install`

Set environment variables, see Configuration section

To run:

`bundle exec clockwork clock.rb`

## Configuration

ENV | Use | Format | Default
--- | --- | --- | ---
TWILIO_ACCOUNT_SID | Twilio Account SID | 
TWILIO_AUTH_TOKEN | Twilio Auth Token | 
TWILIO_SENDER_PHONE_NUMBER | The vertified number of the SMS sender |
TWILIO_RECEIVER_PHONE_NUMBER | The vertified number of the SMS receiver |
SKU_IDS | The comma deliminated SKU IDs | sku_id,sku_id |
COUNTRIES | The comma deliminated country code | code,code |