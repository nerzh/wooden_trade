require 'json'
require 'net/http'
require 'uri'
require 'byebug'
require "tarde_wooden_api/version"
require "tarde_wooden_api/http/http"
require "tarde_wooden_api/telegram/telegram"

require "tarde_wooden_api/exchange/binance/binance"
require "tarde_wooden_api/exchange/poloniex/poloniex"
require "tarde_wooden_api/exchange/cex/cex"
require "tarde_wooden_api/exchange/huobi/huobi"
require "tarde_wooden_api/exchange/exmo/exmo"

require "tarde_wooden_api/core/core"

module TradeWoodenApi
  class << self
    attr_accessor :binance, :cex, :poloniex, :huobi, :exmo
    attr_accessor :api_key, :secret, :tlgrm_bot_token, :telegram_ids, :pairs, :signal_percent, :latency
  end

  def self.configurate
    self.binance, self.cex, self.poloniex, self.huobi, self.exmo = {}, {}, {}, {}, {}
    yield(self)
  end
end
