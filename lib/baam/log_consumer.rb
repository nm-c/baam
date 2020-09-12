# frozen_string_literal: true

require 'bunny'
require 'oj'

module Baam
  class LogConsumer
    def self.run(&block)
      Bunny.run(&block)
    end

    attr_writer :logger

    def initialize(logger)
      @logger = logger
      @name = @logger.class.name
    end

    def log_impl(body, _info, _prop)
      @logger.log(**Oj.load(body))
    end

    def log(connection, &block) # rubocop:disable Metrics/MethodLength
      Thread.start do
        connection.with_channel do |channel|
          block ||= method(:log_impl)
          queue = channel.queue(@name)
          exchange = channel.topic(LogQueue::EXCHANGE_NAME)
          queue.bind(exchange, routing_key: '#')
          queue.subscribe(block: true) do |info, prop, body|
            block.call(body, info, prop)
          end
        end
      end
    end
  end
end
