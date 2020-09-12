# frozen_string_literal: true

module Baam
  class LogCombined < LogBase
    attr_accessor :loggers

    def initialize(loggers = [])
      super()
      @loggers = loggers
    end

    def log_impl(**data)
      @loggers.map { |logger| logger.log(**data) }
    end
  end
end
