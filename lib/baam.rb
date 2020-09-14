# frozen_string_literal: true

require 'baam/version'
require 'baam/log'

module Baam
  autoload :LogBase, 'baam/log_base'
  autoload :LogNil, 'baam/log_nil'
  autoload :LogMeta, 'baam/log_meta'
  autoload :LogCombined, 'baam/log_combined'
  autoload :LogStderr, 'baam/log_stderr'
  autoload :LogQueue, 'baam/log_queue'
  autoload :LogConsumer, 'baam/log_consumer'
  autoload :LogSlack, 'baam/log_slack'
  autoload :LogLoggly, 'baam/log_loggly'
  autoload :LogFilter, 'baam/log_filter'

  L.append_timestamp
  L = LogStderr.new
  L.append_timestamp
  L.level = :warn
end
