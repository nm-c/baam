# frozen_string_literal: true

require 'active_support/cache'

module Baam
  class LogFilter < LogBase
    class MemoryCountStore < ActiveSupport::Cache::MemoryStore
      def modify(name, **options)
        synchronize do
          options = merged_options(options)
          num = read(name, options)
          num = yield(num)
          write(name, num, options)
          num
        end
      end

      def with_mark(name, expires_in, **options)
        synchronize do
          name = [name, :mark]
          options = merged_options(expires_in: expires_in, **options)
          mark = read(name, options)
          result, should_mark = yield(mark)
          write(name, true, options) if !mark || should_mark
          result
        end
      end

      def next_period(name, period: Float::INFINITY, expires_in: nil, **options)
        with_mark(name, expires_in, **options) do |mark|
          modify(name, **options) do |num|
            mark ? (num + 1) % period : 0
          end.then do |value|
            [value, value.zero?]
          end
        end
      end
    end

    attr_writer :logger

    def initialize(
      logger: LogNil.new, namespace: 'log_filter',
      option: {}, group_by: nil
    )
      super()
      @logger = logger
      @store = ActiveSupport::Cache.lookup_store(
        MemoryCountStore.new(namespace: namespace),
      )
      @option = option
      @group_by = group_by || lambda do |**data|
        data.fetch(:filter, {}).fetch(:key, nil)
      end
    end

    def log_impl(**data)
      @logger.log(**data)
    end

    def log?(**data)
      return false unless super

      group = @group_by.call(**data)
      option = @option.fetch(group, {})
      option = { period: 1 } if option.empty?
      @store.next_period(group, **option).zero?
    end
  end
end
