# frozen_string_literal: true

require 'time'
require 'timecop'

RSpec.describe Baam::LogMeta do
  let(:data) { { msg: 'msg' } }
  let(:meta) { { key: :value } }

  describe '#log' do
    it 'calls #logger#log' do
      logger = Baam::LogBase.new
      expect(logger).to receive(:log).with(**data).once

      subject.logger = logger
      subject.log(**data)
    end

    it 'does not raise any error' do
      subject.log(**data)
    end
  end

  describe '#meta' do
    it 'works' do
      expect(subject).to receive(:log_impl).with(**meta, **data).once
      subject.meta = meta
      subject.log(**data)
    end

    it 'works deeply' do
      expect(subject).to receive(:log_impl).with(meta: { meta: true, msg: true }).once
      subject.meta = { meta: { meta: true } }
      subject.log(meta: { msg: true })
    end
  end

  describe '#put' do
    it 'works' do
      subject.put(**meta)
      expect(subject.meta).to eq(meta: meta)
    end

    it 'works deeply' do
      subject.put(key: { key1: :value1 })
      subject.put(key: { key2: :value2 })
      expect(subject.meta).to eq(meta: { key: { key1: :value1, key2: :value2 } })
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

    it 'works deeply' do
      expect(subject.meta).to be_empty
      subject.with(meta: { a: :a }) do
        expect(subject.meta).to eq(meta: { a: :a })
        subject.with(meta: { b: :b }) do
          expect(subject.meta).to eq(meta: { a: :a, b: :b })
        end
        expect(subject.meta).to eq(meta: { a: :a })
      end
      expect(subject.meta).to be_empty
    end
  end

  describe '#put_host' do
    it 'works' do
      expect(subject).to receive(:host).and_return('hostname')
      subject.put_host
      expect(subject.meta).to eq(meta: { host: 'hostname' })
    end
  end

  describe '#put_ip' do
    it 'works' do
      expect(subject).to receive(:ip).and_return('127.0.0.1')
      subject.put_ip
      expect(subject.meta).to eq(meta: { ip: '127.0.0.1' })
    end
  end

  describe '#put_name' do
    it 'works' do
      subject.put_name('name')
      expect(subject.meta).to eq(meta: { name: 'name' })
    end
  end

  describe '#append_timestamp' do
    it 'works' do
      subject.append_timestamp
      Timecop.freeze(Time.at(0)) do
        expect(subject.manipulate_meta({})).to eq(ts: 0.0)
      end
    end
  end
end
