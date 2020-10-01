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
DE_SKU_IDS | The comma deliminated SKU IDs for DE store | string,string |
DK_SKU_IDS | The comma deliminated SKU IDs for DK store | string,string |
LU_SKU_IDS | The comma deliminated SKU IDs for LU store | string,string |
BE_SKU_IDS | The comma deliminated SKU IDs for BE store | string,string |
IE_SKU_IDS | The comma deliminated SKU IDs for IE store | string,string |
MC_SKU_IDS | The comma deliminated SKU IDs for MC store | string,string |
NL_SKU_IDS | The comma deliminated SKU IDs for NL store | string,string |
AT_SKU_IDS | The comma deliminated SKU IDs for AT store | string,string |
FI_SKU_IDS | The comma deliminated SKU IDs for FI store | string,string |
SE_SKU_IDS | The comma deliminated SKU IDs for SE store | string,string |
FR_SKU_IDS | The comma deliminated SKU IDs for FR store | string,string |
IT_SKU_IDS | The comma deliminated SKU IDs for IT store | string,string |
GB_SKU_IDS | The comma deliminated SKU IDs for GB store | string,string |
RU_SKU_IDS | The comma deliminated SKU IDs for RU store | string,string |
US_SKU_IDS | The comma deliminated SKU IDs for US store | string,string |
BR_SKU_IDS | The comma deliminated SKU IDs for BR store | string,string |
CA_SKU_IDS | The comma deliminated SKU IDs for CA store | string,string |
NZ_SKU_IDS | The comma deliminated SKU IDs for NZ store | string,string |
MY_SKU_IDS | The comma deliminated SKU IDs for MY store | string,string |
SG_SKU_IDS | The comma deliminated SKU IDs for SG store | string,string |
AU_SKU_IDS | The comma deliminated SKU IDs for AU store | string,string |
CN_SKU_IDS | The comma deliminated SKU IDs for CN store | string,string |
TW_SKU_IDS | The comma deliminated SKU IDs for TW store | string,string |
JP_SKU_IDS | The comma deliminated SKU IDs for JP store | string,string |
KR_SKU_IDS | The comma deliminated SKU IDs for KR store | string,string |
HK_SKU_IDS | The comma deliminated SKU IDs for HK store | string,string |
STOCK_CHECK_FREQUENCY | The recurring time to check stock in second | integer | 5
NOTIFICATION_CLEAR_FREQUENCY | The recurring time to notify user in second | integer | 7200
SENDGRID_API_KEY | SendGrid API Key | string
NOTIFY_TO_EMAIl | The email to send email notification to | string