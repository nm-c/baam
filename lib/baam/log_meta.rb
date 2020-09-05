# frozen_string_literal: true

require 'active_support/core_ext/hash/deep_merge'

module Baam
  class LogMeta < LogBase
    attr_writer :logger
    attr_accessor :meta

    def initialize(logger = LogNil.new)
      super()
      @logger = logger
      @meta = {}
    end

    def manipulate_data(data)
      @meta.deep_merge(**super)
    end

    def log_impl(data)
      @logger.log(data)
    end

    def put(data)
      @meta = @meta.deep_merge(meta: data)
    end

    def with(meta)
      orig_meta = @meta
      @meta = @meta.deep_merge(**meta)
      yield
    ensure
      @meta = orig_meta
    end
  end
end
