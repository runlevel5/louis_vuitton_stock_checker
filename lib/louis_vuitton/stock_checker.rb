require 'uri'
require 'httparty'

module LouisVuitton
  class StockChecker
    # LV API-TPC accepts 2 query:
    # storeLang: which is one of STORES
    # skuIdList: comma deliminated SKU IDS, for example: M58009,M58010
    API_URL = 'https://secure.louisvuitton.com/ajaxsecure/getStockLevel.jsp'
    STORES = {
      'DE' => { # Germany
        store_languages: ['deu-de']
      },
      'DK' => { # Denmark
        store_languages: ['eng-nl'],
        invoicing_country: 'DK'
      },
      'LU' => { # Luxembourg
        store_languages: ['eng-nl'],
        invoicing_country: 'LU'
      },
      'BE' => { # Belgium
        store_languages: ['eng-nl'],
        invoicing_country: 'BE'
      },
      'IE' => { # Ireland
        store_languages: ['eng-nl'],
        invoicing_country: 'IE'
      },
      'MC' => { # Monaco
        store_languages: ['eng-nl'],
        invoicing_country: 'MC'
      },
      'NL' => { # Netherlands
        store_languages: ['eng-nl'],
        invoicing_country: 'NL'
      },
      'AT' => { # Austria
        store_languages: ['eng-nl'],
        invoicing_country: 'AT'
      },
      'FI' => { # Finland
        store_languages: ['eng-nl'],
        invoicing_country: 'FI'
      },
      'SE' => { # Sweden
        store_languages: ['eng-nl'],
        invoicing_country: 'SE'
      },
      'ES' => {
        store_languages: ['esp-es']
      },
      'FR' => { # France
        store_languages: ['fra-fr']
      },
      'IT' => { # Italy
        store_languages: ['ita-it']
      },
      'GB' => { # UK
        store_language: ['eng-gb']
      },
      'RU' => { # Russia
        store_languages: ['rus-ru']
      },
      'US' => { # USA
        store_languages: ['eng-us']
      },
      'BR' => { # Brazil
        store_languages: ['por-br']
      },
      'CA' => { # Canada
        store_languages: ['eng-ca', 'fra-ca']
      },
      'NZ' => { # New Zealand
        store_languages: ['eng-sg'],
        invoicing_country: 'NZ'
      },
      'MY' => { # Malaysia
        store_languages: ['eng-sg'],
        invoicing_country: 'MY'
      },
      'SG' => { # Singapore
        store_languages: ['eng-sg'],
        invoicing_country: 'SG'
      },
      'AU' => { # Australia
        store_languages: ['eng-au']
      },
      'CN' => { # China
        store_languages: ['zhs-cn']
      },
      'TW' => { # Taiwan
        store_languages: ['zht-tw']
      },
      'JP' => { # Japan
        store_languages: ['jpn-jp']
      },
      'KR' => { # Korea
        store_languages: ['kor-kr']
      },
      'HK' => { # Hong Kong
        store_languages: ['eng-hk', 'zht-hk']
      }
    }

    def self.check_stock_for(sku_ids: [], country_code:)
      raise ArgumentError, 'SKU ID must be an array of SKU IDs' unless sku_ids.is_a? Array  
      raise ArgumentError, 'Invalid country code' unless STORES.keys.include?(country_code)

      results = {}
      results[country_code] = {}
      invoicing_country = STORES.dig(country_code, :invoicing_country)

      STORES.dig(country_code, :store_languages).each do |store_language|
        results[country_code][store_language] = self.new.get_stock_level(store_language: store_language, sku_id_list: sku_ids, dispatch_country: invoicing_country)
      end

      results
    end

    def get_stock_level(store_language:, sku_id_list: [], dispatch_country: nil)
      sku_id_list = sku_id_list.join(',')

      query = {
        'storeLang' => store_language,
        'skuIdList' => sku_id_list
      }

      if dispatch_country
        query['dispatchCountry'] = dispatch_country
      end

      $logger.info query.to_s

      url = URI::HTTPS.build(host: 'api-tpc.louisvuitton.com', path: '/ajaxsecure/getStockLevel.jsp', query: URI.encode_www_form(query))
      begin
        response = HTTParty.get(url, format: :json)
      rescue HTTParty::Error
        logger.error "Failed to fetch #{query.to_s}"
        return nil
      rescue StandardError => e
        logger.error e.backtrace
        raise
      end

      response.parsed_response
    end
  end
end
