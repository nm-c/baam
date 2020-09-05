# frozen_string_literal: true

module Baam
  class LogNil
    def log_impl(data); end

    def log(data)
      log_impl(data)
    end
  end
end
