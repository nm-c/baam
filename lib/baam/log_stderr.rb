# frozen_string_literal: true

require 'active_support/core_ext/object/deep_dup'
require 'oj'

module Baam
  class LogStderr < LogBase
    def initialize(io = $stderr)
      super()
      @io = io
    end

    def log_impl(**data)
      write(format(**data))
    end

    def format(**data)
      data = data.deep_dup
      short_level =
        (data.delete(:level) || LEVEL_NAME.first).to_s[0, 1].upcase
      localtime = ENV.fetch('LOCALTIME', '+00:00')
      ts = data.delete(:ts) || 0
      time = Time.at(ts).localtime(localtime).strftime('%T%z')
      msg = data.delete(:msg)
      "#{short_level}]#{time} #{Oj.dump(data, mode: :compat)} #{msg}\n"
    end

    def write(data)
      @io.write(data)
    end
  end
end
