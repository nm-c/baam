# frozen_string_literal: true

require_relative '../baam'

LS = Baam::LogMeta.new(Baam::LogStderr.new)
LS.put_host
LS.put_ip
LS.append_timestamp

L = Baam::LogMeta.new(
  Baam::LogCombined.new(
    [
      Baam::LogStderr.new,
      Baam::LogQueue.new,
    ],
  ),
)
L.put_host
L.put_ip
L.append_timestamp
