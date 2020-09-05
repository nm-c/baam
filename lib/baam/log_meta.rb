# frozen_string_literal: true

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
      @meta.merge(**super)
    end

    def log_impl(data)
      @logger.log(data)
    end
  end
end
