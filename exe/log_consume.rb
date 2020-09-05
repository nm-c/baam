# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'dotenv/load'
require 'baam'
require 'baam/simple'

LS.put_name('LogConsume')

LS.notice('Started')

at_exit do
  LS.notice('Finished')
end

log_consumers = [
  Baam::LogConsumer.new(Baam::LogStderr.new),
  Baam::LogConsumer.new(Baam::LogSlack.new),
  Baam::LogConsumer.new(Baam::LogLoggly.new),
]

Baam::LogConsumer.run do |connection|
  log_consumers.map do |log|
    log.log(connection)
  end.map(&:join)
end
