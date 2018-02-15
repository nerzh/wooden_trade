module TradeWoodenApi
  module Http
      
    def get_request(url, data={}, headers={})
      url  = URI.parse(url)
      Net::HTTP.get(url)
    end
    
  end
end