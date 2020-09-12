# frozen_string_literal: true

RSpec.describe Baam::LogCombined do
  let(:data) { { msg: 'msg' } }

  describe '#log' do
    it 'calls log_impl' do
      loggers = [Baam::LogBase.new, Baam::LogBase.new]
      loggers.each do |logger|
        expect(logger).to receive(:log).with(data)
      end
      subject.loggers = loggers
      subject.log(**data)
    end
  end
end
