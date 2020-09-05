# frozen_string_literal: true

module Baam
  class LogNil < LogBase
    def log_impl(data); end
  end
end
