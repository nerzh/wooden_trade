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
        sleep TradeWoodenApi.latency
        if block_given?
          yield(self)
        end
      end
    end
  end
end













