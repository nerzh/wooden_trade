module TradeWoodenApi
  module Poloniex
    class Rest
      include TradeWoodenApi::Http

      attr_accessor :api_url, :api_key, :secret

      def initialize(api_url, api_key, secret)
        self.api_url = api_url
        self.api_key = api_key
        self.secret  = secret
      end

      def get_pair_price(symbol_1, symbol_2)
        get_pair(symbol_1, symbol_2)["last"]
      rescue => ex
        nil
      end

      private

      def get_pair(symbol_1, symbol_2)
        url        = '/public'
        uri        = "#{api_url}#{url}?command=returnTicker"
        response   = JSON.parse(get_request(uri))
        response["#{symbol_2}_#{symbol_1}"]
      rescue => ex
        nil
      end

    end
  end
end