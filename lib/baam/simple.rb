require_relative '../baam'

LS = Baam::LogMeta.new(Baam::LogStderr.new)
LS.put_host
LS.append_timestamp
