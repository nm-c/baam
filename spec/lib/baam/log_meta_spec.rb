# frozen_string_literal: true

RSpec.describe Baam::LogMeta do
  let(:data) { { msg: 'msg' } }
  let(:meta) { { key: :value } }

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
      expect(subject).to receive(:log_impl).with(**meta, **data).once
      subject.meta = meta
      subject.log(data)
    end
  end

  describe '#put' do
    it 'works' do
      subject.put(meta)
      expect(subject.meta).to eq(meta: meta)
    end
  end

  describe '#with' do
    it 'works' do
      expect(subject.meta).to be_empty
      subject.with(a: :a) do
        expect(subject.meta).to eq(a: :a)
        subject.with(b: :b) do
          expect(subject.meta).to eq(a: :a, b: :b)
        end
        expect(subject.meta).to eq(a: :a)
      end
      expect(subject.meta).to be_empty
    end
  end
end
