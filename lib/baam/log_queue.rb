# frozen_string_literal: true

require 'bunny'
require 'oj'

module Baam
  class LogQueue < LogBase
    EXCHANGE_NAME = 'log'

    def initialize
      super
      @connection = Bunny.new
      @connection.start
      @channel = @connection.create_channel

      @exchange = @channel.topic(EXCHANGE_NAME)

      at_exit do
        @channel.close
        @connection.close
      end
    end

    def log_impl(data)
      @exchange.publish(Oj.dump(data))
    end
  end
end
