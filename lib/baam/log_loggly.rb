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

    def log_impl(data)
      data = format(data)
      HTTParty.post(
        @url,
        headers: { 'Content-Type': 'application/json' },
        body: data,
      )
    end

    def format(data)
      data = data.deep_dup
      if data.key?(:ts)
        ts = data.fetch(:ts)
        time = Time.at(ts).utc.strftime('%FT%T%:z')
        data[:ts] = time
      end
      Oj.dump(data, mode: :compat)
    end
  end
end
