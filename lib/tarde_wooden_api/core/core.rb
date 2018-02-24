module TradeWoodenApi
  class Core

    attr_accessor :bot, :binance, :cex, :poloniex, :huobi, :exmo

    def initialize(bot)
      binance  = TradeWoodenApi.binance
      cex      = TradeWoodenApi.cex
      poloniex = TradeWoodenApi.poloniex
      huobi    = TradeWoodenApi.huobi
      exmo     = TradeWoodenApi.exmo

      self.binance  = TradeWoodenApi::Binance::Rest.new(binance[:api_url], binance[:api_key], binance[:secret])
      self.cex      = TradeWoodenApi::Cex::Rest.new(cex[:id], cex[:api_url], cex[:api_key], cex[:secret])
      self.poloniex = TradeWoodenApi::Poloniex::Rest.new(poloniex[:api_url], poloniex[:api_key], poloniex[:secret])
      self.huobi    = TradeWoodenApi::Huobi::Rest.new(huobi[:api_url])
      self.exmo     = TradeWoodenApi::Exmo::Rest.new(exmo[:api_url])
      self.bot      = bot
    end

    def call
      user = TradeWoodenApi.telegram_ids.first
      loop do
        begin
          TradeWoodenApi.pairs.each do |main_symbol, slave_symbols|
            slave_symbols.each do |symbol|
              b = binance.get_pair_price(symbol, main_symbol).to_f.round(10)
              p = poloniex.get_pair_price(symbol, main_symbol).to_f.round(10)
              c = cex.get_pair_price(symbol, main_symbol).to_f.round(10)
              h = huobi.get_pair_price(symbol, main_symbol).to_f.round(10)
              e = exmo.get_pair_price(symbol, main_symbol).to_f.round(10)
              
              res = {
                b => 'binance',
                p => 'poloniex',
                c => 'cex',
                h => 'huobi',
                e => 'exmo'
              }

              a = res.keys.select{ |val| val > 0 }.sort
              # if a.empty? or a.first <= 0
              if a.first <= 0
                sleep TradeWoodenApi.latency
                next
              else
                r = (a.last * 100)/a.first - 100
              end

              text = "#{symbol}/#{main_symbol}%0A"
              res.each { |price, name| text << "#{name} - #{price}%0A" if price > 0 }
              text << "----------------------------%0A"\
              "#{res[a.first]} < #{res[a.last]}%0A"\
              "max difference #{r.round(5)} %%0A"\
              "----------------------------"
                          
              TradeWoodenApi.telegram_ids.each do |user|
                bot.send_message(user, text)
              end if r >= TradeWoodenApi.signal_percent
              sleep TradeWoodenApi.latency
            end
          end
        rescue => ex
          TradeWoodenApi.telegram_ids.each do |user|
            bot.send_message(user, 'Хозяин, вся эта хуита на сервере хотела ебануться, тошо: #{ex.message}%0AНо я ее, вроде, восстановил! Хорошо вам побарыжить, мой повелитель')
          end
        end
      end
    end
  end
end