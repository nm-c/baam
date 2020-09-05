# frozen_string_literal: true

require 'slack-notifier'
require 'active_support/core_ext/object/deep_dup'
require 'oj'

module Baam
  class LogSlack < LogBase
    def initialize(slack_url = ENV['SLACK_URL'])
      super()
      @slack_url = slack_url
    end

    def log_impl(data)
      data = format(data)
      Slack::Notifier.new(@slack_url, **data[:slack]).ping(data[:msg])
    end

    def format(data)
      data = data.deep_dup
      slack = data.delete(:slack) || {}
      time = Time.at(data.delete(:ts) || 0).utc.strftime('%T')
      msg = data.delete(:msg)
      {
        slack: slack,
        msg: "#{time} #{msg}",
      }
    end
  end
end
