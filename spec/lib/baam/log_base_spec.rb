# frozen_string_literal: true

RSpec.describe Baam::LogBase do
  let(:msg) { 'msg' }
  let(:data) { { msg: msg } }

  describe '#manipulate_data' do
    it 'works with string' do
      expect(subject.manipulate_data(msg)).to eq(data)
    end
    it 'works with hash' do
      expect(subject.manipulate_data(data)).to eq(data)
    end
  end

  describe '#log' do
    it 'calls log_impl' do
      expect(subject).to receive(:log_impl).with(data)
      subject.log(data)
    end

    it 'is not implemented' do
      expect do
        subject.log(data)
      end.to raise_error(NotImplementedError)
    end
  end

  describe '#level' do
    describe '#log?' do
      it 'is truthy with same level' do
        subject.level = :trace
        expect(subject.log?(:trace)).to be_truthy
      end

      it 'is truthy' do
        subject.level = :info
        expect(subject.log?(:info)).to be_truthy
      end

      it 'is falsy' do
        subject.level = :notice
        expect(subject.log?(:info)).to be_falsy
      end
    end

    it 'logs' do
      expect(subject).to receive(:log_impl).once
      subject.level = :trace
      subject.log(level: :trace, msg: msg)
    end

    it 'does not log' do
      subject.level = :info
      subject.log(level: :debug, msg: msg)
    end
  end

  describe 'log with level' do
    it 'works with string' do
      expect(subject).to receive(:log).with(level: :trace, msg: msg)
      subject.trace(msg)
      expect(subject).to receive(:log).with(level: :debug, msg: msg)
      subject.debug(msg)
      expect(subject).to receive(:log).with(level: :info, msg: msg)
      subject.info(msg)
      expect(subject).to receive(:log).with(level: :notice, msg: msg)
      subject.notice(msg)
      expect(subject).to receive(:log).with(level: :warn, msg: msg)
      subject.warn(msg)
      expect(subject).to receive(:log).with(level: :error, msg: msg)
      subject.error(msg)
      expect(subject).to receive(:log).with(level: :fatal, msg: msg)
      subject.fatal(msg)
    end

    it 'works with data' do
      expect(subject).to receive(:log).with(level: :trace, msg: msg)
      subject.trace(data)
      expect(subject).to receive(:log).with(level: :debug, msg: msg)
      subject.debug(data)
      expect(subject).to receive(:log).with(level: :info, msg: msg)
      subject.info(data)
      expect(subject).to receive(:log).with(level: :notice, msg: msg)
      subject.notice(data)
      expect(subject).to receive(:log).with(level: :warn, msg: msg)
      subject.warn(data)
      expect(subject).to receive(:log).with(level: :error, msg: msg)
      subject.error(data)
      expect(subject).to receive(:log).with(level: :fatal, msg: msg)
      subject.fatal(data)
    end
  end
end
