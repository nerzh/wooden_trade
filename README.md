# BinanceWoodenApi

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/binance_wooden_api`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'binance_wooden_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install binance_wooden_api

## Usage

```ruby
require 'trade_wooden_api'

TradeWoodenApi.configurate { |conf|
  # main loop latency
  conf.latency         = 0.3

  conf.pairs = {
    "BTC" => [
      'ETC', 'LTC', 'XRP', 'ZEC', 'TRX', 'XLM', 'ADA', 'BNB', 'EOS', 'BCC', 'ADX', 'VIB', 'VTC',
      'RPL', 'LSK', 'OMG', 'STRAT', 'WAVES', 'ZRX', 'GAS'
    ]
  }
  
  # binance
  conf.binance[:api_url] = 'https://api.binance.com'
  conf.binance[:api_key] = 'api_key'
  conf.binance[:secret]  = 'secret'

  # cex
  conf.cex[:api_url] = 'https://cex.io'
  conf.cex[:id]      = 'id'
  conf.cex[:api_key] = 'api_key'
  conf.cex[:secret]  = 'secret'

  # poloniex
  conf.poloniex[:api_url] = 'https://poloniex.com'
  conf.poloniex[:api_key] = 'api_key'
  conf.poloniex[:secret]  = 'secret'

  # huobi
  conf.huobi[:api_url] = 'https://api.huobi.pro'

  # kraken
  conf.kraken[:api_url] = 'https://api.kraken.com/0'

  # exmo
  conf.exmo[:api_url] = 'https://api.exmo.com/v1'
}

# if need send to telegram
# bot   = TradeWoodenApi::Telegram::Bot.new(TradeWoodenApi.tlgrm_bot_token)
# trade = TradeWoodenApi::Core.new(bot)


trade = TradeWoodenApi::Core.new()

# example main loop
trade.call() do |trade_wooden_api|

  TradeWoodenApi.pairs.each do |main_symbol, slave_symbols|
    slave_symbols.each do |symbol|
      # b = trade_wooden_api.binance.get_pair_price(symbol, main_symbol).to_f.round(10)
      # p = trade_wooden_api.poloniex.get_pair_price(symbol, main_symbol).to_f.round(10)
      # c = trade_wooden_api.cex.get_pair_price(symbol, main_symbol).to_f.round(10)
      h = trade_wooden_api.huobi.get_pair_price(symbol, main_symbol).to_f.round(10)
      k = trade_wooden_api.kraken.get_pair_price(symbol, main_symbol).to_f.round(10)
      e = trade_wooden_api.exmo.get_pair_price(symbol, main_symbol).to_f.round(10)
    end
  end

end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/binance_wooden_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the BinanceWoodenApi project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/binance_wooden_api/blob/master/CODE_OF_CONDUCT.md).
