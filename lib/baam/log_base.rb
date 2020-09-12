# frozen_string_literal: true

module Baam
  class LogBase
    LEVEL_NAME = %i[
      trace
      debug
      info
      notice
      warn
      error
      fatal
    ].freeze
    LEVEL =
      LEVEL_NAME.each.with_index.to_h { |level, enum| [level, enum] }.freeze

    attr_writer :level

    def initialize
      @level = LEVEL.fetch(:trace, 0)
    end

    def log_impl(**data)
      raise NotImplementedError
    end

    def log(**data)
      return unless log?(**data)

      log_impl(**data)
    end

    def manipulate_data(data)
      data.is_a?(Hash) ? data : { msg: data }
    end

    def log?(**data)
      current_level = data.fetch(:level, :debug)
      LEVEL.fetch(@level, 0) <= LEVEL.fetch(current_level, 0)
    end

    LEVEL_NAME.each do |level|
      define_method(level) do |data|
        data = manipulate_data(data)
        log(level: level, **data)
      end
    end
  end
end
