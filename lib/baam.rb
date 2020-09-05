# frozen_string_literal: true

require 'baam/version'
require 'baam/log'

module Baam
  autoload :LogBase, 'baam/log_base'
  autoload :LogNil, 'baam/log_nil'
  autoload :LogMeta, 'baam/log_meta'
  autoload :LogCombined, 'baam/log_combined'
  autoload :LogStderr, 'baam/log_stderr'
end
