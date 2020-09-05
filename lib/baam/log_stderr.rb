# frozen_string_literal: true

require 'oj'

module Baam
  class LogStderr < LogBase
    def initialize(io = $stderr)
      super()
      @io = io
    end

    def log_impl(data)
      write(format(data))
    end

    def format(data)
      short_level =
        (data.delete(:level) || LEVEL_NAME.first).to_s[0, 1].upcase
      time = Time.at(data.delete(:ts) || 0).utc.strftime('%T')
      msg = data.delete(:msg)
      "#{short_level}]#{time} #{Oj.dump(data)} #{msg}"
    end

    def write(data)
      @io.write(data)
    end
  end
end
