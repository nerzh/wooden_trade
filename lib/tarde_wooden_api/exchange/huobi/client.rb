module TradeWoodenApi
  module Huobi
    class Rest
      include TradeWoodenApi::Http

      attr_accessor :api_url, :api_key, :secret

      def initialize(api_url, api_key=nil, secret=nil)
        self.api_url = api_url
        self.api_key = api_key
        self.secret  = secret
      end

      def get_pair_price(symbol_1, symbol_2)
        get_pair(symbol_1, symbol_2)['tick']['data'].first['price']
      rescue => ex
        nil
      end

      private

      def get_pair(symbol_1, symbol_2)
        url        = '/market/trade'
        uri        = "#{api_url}#{url}?symbol=#{symbol_1.downcase}#{symbol_2.downcase}"
        response   = JSON.parse(get_request(uri))
      rescue => ex
        nil
      end

    end
  end
end