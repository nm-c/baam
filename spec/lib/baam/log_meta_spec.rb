# frozen_string_literal: true

RSpec.describe Baam::LogMeta do
  let(:data) { { msg: 'msg' } }

  describe '#log' do
    it 'calls #logger#log' do
      logger = Baam::LogBase.new
      expect(logger).to receive(:log).with(**data).once

      subject.logger = logger
      subject.log(data)
    end

    it 'does not raise any error' do
      subject.log(data)
    end
  end

  describe '#meta' do
    it 'works' do
      meta = { key: :value }
      expect(subject).to receive(:log_impl).with(**meta, **data).once
      subject.meta = meta
      subject.log(data)
    end
  end
end
