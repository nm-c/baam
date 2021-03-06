# frozen_string_literal: true

require 'active_support/core_ext/hash/deep_merge'
require 'httparty'
require 'socket'

module Baam
  class LogMeta < LogBase
    attr_writer :logger
    attr_accessor :meta

    def initialize(logger = LogNil.new)
      super()
      @logger = logger
      @meta = {}
      @append_timestamp = false
    end

    def manipulate_meta(data)
      @meta.deep_merge(
        **(@append_timestamp ? { ts: Time.now.to_f } : {}),
        **data,
      )
    end

    def log_impl(**data)
      @logger.log(**data)
    end

    def log(**data)
      super(**manipulate_meta(data))
    end

    def put(**data)
      @meta = @meta.deep_merge(meta: data)
    end

    def with(**meta)
      orig_meta = @meta
      @meta = @meta.deep_merge(**meta)
      yield
    ensure
      @meta = orig_meta
    end

    # :nocov:
    def host
      @host ||= ENV.fetch('HOST_HOSTNAME') { Socket.gethostname }
    end
    # :nocov:

    def put_host
      put(host: host)
    end

    # :nocov:
    def ip
      @ip ||= HTTParty.get('http://api.ipify.org').body
    end
    # :nocov:

    def put_ip
      put(ip: ip)
    end

    def put_name(name)
      put(name: name)
    end

    def append_timestamp
      @append_timestamp = true
    end
  end
end
