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
    end

    def log_impl(body, _info, _prop)
      @logger.log(**Oj.load(body))
    end

    def log(connection, &block) # rubocop:disable Metrics/MethodLength
      Thread.start do
        connection.with_channel do |channel|
          block ||= method(:log_impl)
          queue = channel.queue('', auto_delete: true)
          exchange = channel.topic(LogQueue::EXCHANGE_NAME)
          queue.bind(exchange, routing_key: '#')
          queue.subscribe(block: true) do |info, prop, body|
            L.trace(info: info, prop: prop, body: body)
            L.debug(queue: info.consumer.queue.name, body: Oj.load(body))
            block.call(body, info, prop)
          end
        end
      end
    end
  end
end
