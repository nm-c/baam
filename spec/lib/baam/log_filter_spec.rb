# frozen_string_literal: true

RSpec.describe Baam::LogFilter do
  describe described_class::MemoryCountStore do
    subject { described_class.new }

    it 'works with default' do
      expect(subject.next_period(:a, period: 3)).to eq(0)
      expect(subject.next_period(:a, period: 3)).to eq(1)
      expect(subject.next_period(:a, period: 3)).to eq(2)
      expect(subject.next_period(:a, period: 3)).to eq(0)
    end

    it 'works with mark with last zero' do
      Timecop.freeze(Time.at(0)) do
        expect(subject.next_period(:a, period: 3, expires_in: 60)).to eq(0)
      end
      Timecop.freeze(Time.at(10)) do
        expect(subject.next_period(:a, period: 3, expires_in: 60)).to eq(1)
      end
      Timecop.freeze(Time.at(20)) do
        expect(subject.next_period(:a, period: 3, expires_in: 60)).to eq(2)
      end
      Timecop.freeze(Time.at(30)) do
        expect(subject.next_period(:a, period: 3, expires_in: 60)).to eq(0)
      end
      Timecop.freeze(Time.at(40)) do
        expect(subject.next_period(:a, period: 3, expires_in: 60)).to eq(1)
      end
      Timecop.freeze(Time.at(90)) do
        expect(subject.next_period(:a, period: 3, expires_in: 60)).to eq(0)
      end
    end

    it 'works zero again after period' do
      Timecop.freeze(Time.at(0)) do
        expect(subject.next_period(:a, period: 3, expires_in: 60)).to eq(0)
      end
      Timecop.freeze(Time.at(60)) do
        expect(subject.next_period(:a, period: 3, expires_in: 60)).to eq(0)
      end
    end
  end

  let(:data) { { msg: 'msg' } }

  subject do
    described_class.new(
      option: {
        a: { period: 3, expires_in: 60 },
        b: { period: 2 },
        c: { expires_in: 3 },
      },
    )
  end

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

  describe '#log?' do
    it 'works with level' do
      subject.level = :trace
      expect(subject.log?).to be_truthy

      subject.level = :info
      expect(subject.log?).to be_falsy
    end

    it 'works with period' do
      expect(subject.log?(filter: { key: :a })).to be_truthy
      expect(subject.log?(filter: { key: :a })).to be_falsy
      expect(subject.log?(filter: { key: :a })).to be_falsy
      expect(subject.log?(filter: { key: :a })).to be_truthy
    end

    it 'works with mark' do
      Timecop.freeze(Time.at(0)) do
        expect(subject.log?(filter: { key: :a })).to be_truthy
      end
      Timecop.freeze(Time.at(30)) do
        expect(subject.log?(filter: { key: :a })).to be_falsy
      end
      Timecop.freeze(Time.at(60)) do
        expect(subject.log?(filter: { key: :a })).to be_truthy
      end
    end

    it 'works with mark' do
      Timecop.freeze(Time.at(0)) do
        expect(subject.log?(filter: { key: :a })).to be_truthy
        expect(subject.log?(filter: { key: :a })).to be_falsy
        expect(subject.log?(filter: { key: :a })).to be_falsy
      end
      Timecop.freeze(Time.at(10)) do
        expect(subject.log?(filter: { key: :a })).to be_truthy
      end
      Timecop.freeze(Time.at(70)) do
        expect(subject.log?(filter: { key: :a })).to be_truthy
      end
    end

    it 'works with keys' do
      Timecop.freeze(Time.at(0)) do
        expect(subject.log?(filter: { key: :a })).to be_truthy
        expect(subject.log?(filter: { key: :b })).to be_truthy
        expect(subject.log?(filter: { key: :b })).to be_falsy
        expect(subject.log?(filter: { key: :b })).to be_truthy
      end
      Timecop.freeze(Time.at(60)) do
        expect(subject.log?(filter: { key: :a })).to be_truthy
        expect(subject.log?(filter: { key: :b })).to be_falsy
      end
    end

    it 'works with only mark' do
      Timecop.freeze(Time.at(0)) do
        expect(subject.log?(filter: { key: :c })).to be_truthy
        10.times { expect(subject.log?(filter: { key: :c })).to be_falsy }
      end
      Timecop.freeze(Time.at(3)) do
        expect(subject.log?(filter: { key: :c })).to be_truthy
        10.times { expect(subject.log?(filter: { key: :c })).to be_falsy }
      end
    end

    it 'works with default' do
      Timecop.freeze(Time.at(0)) do
        expect(subject.log?).to be_truthy
        expect(subject.log?).to be_truthy
      end
      Timecop.freeze(Time.at(60)) do
        expect(subject.log?).to be_truthy
      end
    end
  end
end
