# frozen_string_literal: true

RSpec.describe Baam::LogStderr do
  let(:data) { { msg: 'msg' } }

  describe '#format' do
    it 'works' do
      expect(subject.format(data)).to eq('{} msg')
    end
  end

  describe '#log_impl' do
    it 'calls #write and #format' do
      expect(subject).to receive(:write).once
      expect(subject).to receive(:format).with(data).once
      subject.log_impl(data)
    end
  end

  describe '#write' do
    it 'writes' do
      expect { subject.write('msg') }.to output('msg').to_stderr
    end
  end
end
