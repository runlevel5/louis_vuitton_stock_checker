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
TWILIO_ACCOUNT_SID | Twilio Account SID | string
TWILIO_AUTH_TOKEN | Twilio Auth Token | string
TWILIO_SENDER_PHONE_NUMBER | The vertified number of the SMS sender | string
TWILIO_RECEIVER_PHONE_NUMBER | The vertified number of the SMS receiver | string
SKU_IDS | The comma deliminated SKU IDs | string,string |
COUNTRIES | The comma deliminated country code | string,string |
STOCK_CHECK_FREQUENCY | The recurring time to check stock in second | integer | 5
NOTIFICATION_CLEAR_FREQUENCY | The recurring time to notify user in second | integer | 7200
SENDGRID_API_KEY | SendGrid API Key | string
NOTIFY_TO_EMAIl | The email to send email notification to | string