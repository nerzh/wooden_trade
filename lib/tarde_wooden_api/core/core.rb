require 'uri'

module TradeWoodenApi
  class Core

    attr_accessor :bot, :binance, :cex, :poloniex, :huobi, :kraken, :exmo

    def initialize(bot)
      binance  = TradeWoodenApi.binance
      cex      = TradeWoodenApi.cex
      poloniex = TradeWoodenApi.poloniex
      huobi    = TradeWoodenApi.huobi
      exmo     = TradeWoodenApi.exmo
      kraken   = TradeWoodenApi.kraken

      self.binance  = TradeWoodenApi::Binance::Rest.new(binance[:api_url], binance[:api_key], binance[:secret])
      self.cex      = TradeWoodenApi::Cex::Rest.new(cex[:id], cex[:api_url], cex[:api_key], cex[:secret])
      self.poloniex = TradeWoodenApi::Poloniex::Rest.new(poloniex[:api_url], poloniex[:api_key], poloniex[:secret])
      self.huobi    = TradeWoodenApi::Huobi::Rest.new(huobi[:api_url])
      self.exmo     = TradeWoodenApi::Exmo::Rest.new(exmo[:api_url])
      self.kraken   = TradeWoodenApi::Kraken::Rest.new(kraken[:api_url])
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
              k = kraken.get_pair_price(symbol, main_symbol).to_f.round(10)
              e = exmo.get_pair_price(symbol, main_symbol).to_f.round(10)
              
              res = {
                b => 'binance',
                p => 'poloniex',
                c => 'cex',
                h => 'huobi',
                e => 'exmo',
                k => 'kraken'
              }

              a = res.keys.select{ |val| val > 0 }.sort
              if a.empty? or a.first <= 0
                sleep TradeWoodenApi.latency
                next
              else
                r = (a.last * 100)/a.first - 100
              end

              text = "#{symbol}/#{main_symbol} - #{r.round(4)} %\n"
              text << "#{res[a.first]} < #{res[a.last]}\n"
              text << "-----------------------------\n"
              res.sort.each { |price, name| text << "#{make_string(res.keys, price.to_s)} - #{make_string(res.values, name)} - #{get_percent(get_min_price(res.keys), price).round(2) } %\n" if price > 0 }
                                    
              TradeWoodenApi.telegram_ids.each do |user|
                # text = "Гав! Гав! Позовите хозяина, эти биржи меня обижают: Error: You are blocked. Еxceeded limit"
                bot.send_message(user, URI::encode(text))
              end if r >= TradeWoodenApi.signal_percent
              sleep TradeWoodenApi.latency
            end
          end
        rescue => ex
          TradeWoodenApi.telegram_ids.each do |user|
            bot.send_message(user, URI::encode("Хозяин, вся эта хуита на сервере хотела ебануться, тошо: #{ex.message}\nНо я ее, вроде, восстановил! Хорошо вам побарыжить, мой повелитель"))
          end
        end
      end
    end

    def max_length(arr_str)
      l = nil
      arr_str.each do |price|
        l ||= price.to_s.size
        l   = price.to_s.size if price.to_s.size > l
      end
      l
    end

    def make_string(all_string, string)
      string = string + ''
      max = max_length(all_string)
      (max - string.size).times { string << '  ' }
      string
    end

    def get_percent(price, price2)
      (price2*100)/price - 100
    end

    def get_min_price(array)
      min = 0
      array.sort.each { |val| (min = val; break) if val > 0 }
      min
    end
  end
end













