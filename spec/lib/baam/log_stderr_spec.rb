# frozen_string_literal: true

RSpec.describe Baam::LogStderr do
  let(:data) { { msg: 'msg' } }

  before do
    @localtime = ENV.delete('LOCALTIME')
  end

  after do
    ENV['LOCALTIME'] = @localtime if @localtime
  end

  describe '#format' do
    it 'works with msg' do
      expect(subject.format(**data)).to eq("T]00:00:00+0000 {} msg\n")
    end

    it 'works with level' do
      expect(subject.format(level: :notice)).to eq("N]00:00:00+0000 {} \n")
    end

    it 'works with timestamp' do
      expect(subject.format(ts: 1234.0)).to eq("T]00:20:34+0000 {} \n")
    end

    it 'works with meta' do
      expect(subject.format(key: :value)).to eq("T]00:00:00+0000 {\"key\":\"value\"} \n")
    end

    it 'works with bigdecimal' do
      expect(subject.format(value: BigDecimal('0.123456789'))).to eq("T]00:00:00+0000 {\"value\":0.123456789e0} \n")
    end
  end

  describe '#log_impl' do
    it 'calls #write and #format' do
      expect(subject).to receive(:write).once
      expect(subject).to receive(:format).with(data).once
      subject.log_impl(**data)
    end
  end

  describe '#write' do
    it 'writes' do
      expect { subject.write('msg') }.to output('msg').to_stderr
    end
  end
end
