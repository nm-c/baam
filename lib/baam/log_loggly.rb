# frozen_string_literal: true

require 'httparty'
require 'active_support/core_ext/object/deep_dup'
require 'oj'

module Baam
  class LogLoggly < LogBase
    def initialize(url = ENV['LOGGLY_URL'])
      super()
      @url = url
    end

    def log_impl(**data)
      data = format(**data)
      HTTParty.post(
        @url,
        headers: { 'Content-Type': 'application/json' },
        body: data,
      )
    end

    def format(**data)
      data = data.deep_dup
      if data.key?(:ts)
        localtime = ENV.fetch('LOCALTIME', '+00:00')
        ts = data.delete(:ts)
        time = Time.at(ts).localtime(localtime).iso8601(3)
        data[:timestamp] = time
      end
      Oj.dump(data, mode: :rails, bigdecimal_as_decimal: true)
    end
  end
end
