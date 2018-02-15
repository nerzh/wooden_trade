module TradeWoodenApi
  module Telegram
    class Bot
      include TradeWoodenApi::Http
      
      attr_accessor :token, :bot_url

      def initialize(token)
        self.token   = token
        self.bot_url = "https://api.telegram.org/bot#{self.token}"
      end

      def send_message(user_id, message)
        uri = "#{bot_url}/sendMessage?chat_id=#{user_id}&text=#{message}"
        get_request(uri)
      end
    end
    
  end
end