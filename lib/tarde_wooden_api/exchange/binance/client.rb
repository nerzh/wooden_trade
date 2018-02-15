module TradeWoodenApi
  module Binance
    class Rest
      include TradeWoodenApi::Http

      attr_accessor :api_url, :api_key, :secret

      API_PEFIX = '/api'

      def initialize(api_url, api_key, secret)
        self.api_url = api_url + API_PEFIX
        self.api_key = api_key
        self.secret  = secret
      end

      def get_pair_price(symbol_1, symbol_2)
        get_pair(symbol_1, symbol_2)["price"]
      rescue => ex
        nil
      end

      private

      def get_pair(symbol_1, symbol_2)
        url      = '/v3/ticker/price'
        response = JSON.parse(get_request("#{api_url}/#{url}?symbol=#{symbol_1.upcase}#{symbol_2.upcase}"))
        return nil if response.key?('code')

        response
      rescue => ex
        nil
      end

    end
  end
end