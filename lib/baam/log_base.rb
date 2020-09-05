# frozen_string_literal: true

module Baam
  class LogBase
    def log_impl(data)
      raise NotImplementedError
    end

    def log(data)
      log_impl(data)
    end
  end
end
