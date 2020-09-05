# frozen_string_literal: true

module Baam
  class LogBase
    LEVEL = {
      trace: 0,
      debug: 1,
      info: 2,
      notice: 3,
      warn: 4,
      error: 5,
      fatal: 6,
    }.freeze

    attr_writer :level

    def initialize
      @level = LEVEL.fetch(:trace, 0)
    end

    def log_impl(data)
      raise NotImplementedError
    end

    def log(data)
      data = manipulate_data(data)
      return unless log?(data.fetch(:level, :debug))

      log_impl(data)
    end

    def manipulate_data(data)
      data.is_a?(Hash) ? data : { msg: data }
    end

    def log?(current_level)
      LEVEL.fetch(@level, 0) <= LEVEL.fetch(current_level, 0)
    end
  end
end
