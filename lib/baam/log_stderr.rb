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
      msg = data.delete(:msg)
      "#{Oj.dump(data)} #{msg}"
    end

    def write(data)
      @io.write(data)
    end
  end
end
