module TradeWoodenApi
  module Cex
    class Rest
      include TradeWoodenApi::Http

      attr_accessor :api_url, :api_key, :secret

      def initialize(id, api_url, api_key=nil, secret=nil)
        self.api_url = api_url
        self.api_key = api_key
        self.secret  = secret
      end

      def get_pair_price(symbol_1, symbol_2)
        get_pair(symbol_1, symbol_2)['data'].select{ |pair| pair['pair'] == "#{symbol_1.upcase}:#{symbol_2.upcase}" }.first['last']
      rescue => ex
        nil
      end

      private

      def get_pair(symbol_1, symbol_2)
        url        = '/api/tickers'
        uri        = "#{api_url}#{url}/#{symbol_1.upcase}/#{symbol_2.upcase}"
        response   = JSON.parse(get_request(uri))
      rescue => ex
        nil
      end

    end
  end
end