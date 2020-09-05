# frozen_string_literal: true

RSpec.describe Baam::LogLoggly do
  let(:url) { 'https://stub_url' }

  subject { described_class.new(url) }

  before do
    @localtime = ENV.delete('LOCALTIME')
  end

  after do
    ENV['LOCALTIME'] = @localtime if @localtime
  end

  describe '#format' do
    it 'works with msg' do
      expect(subject.format(msg: 'msg')).to eq('{"msg":"msg"}')
    end

    it 'works with timestamp' do
      expect(subject.format(ts: 1234.0)).to eq('{"timestamp":"1970-01-01T00:20:34.000+00:00"}')
    end
  end

  describe '#log_impl' do
    it 'calls #write and #format' do
      expect(HTTParty).to receive(:post).once
      subject.log_impl(msg: 'msg')
    end
  end
end
