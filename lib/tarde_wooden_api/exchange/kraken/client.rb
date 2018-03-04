module TradeWoodenApi
  module Kraken
    class Rest
      include TradeWoodenApi::Http

      attr_accessor :api_url, :api_key, :secret

      def initialize(api_url, api_key='', secret='')
        self.api_url = api_url
        self.api_key = api_key
        self.secret  = secret
      end

      def get_pair_price(symbol_1, symbol_2)
        get_pair(symbol_1, symbol_2)['c'].first
      rescue => ex
        nil
      end

      private

      def get_pair(symbol_1, symbol_2)
        symbol_2   = symbol_2.upcase.gsub(/BTC/, 'XBT')
        url        = '/public/Ticker'
        uri        = "#{api_url}#{url}?pair=#{symbol_2}#{symbol_1}"
        response   = JSON.parse(get_request(uri))
        response['result']["X#{symbol_1}X#{symbol_2}"]
      rescue => ex
        nil
      end

    end
  end
end