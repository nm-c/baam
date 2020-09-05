# frozen_string_literal: true

RSpec.describe Baam::LogSlack do
  let(:slack_url) { 'https://stub_url' }

  subject { described_class.new(slack_url) }

  before do
    @localtime = ENV.delete('LOCALTIME')
  end

  after do
    ENV['LOCALTIME'] = @localtime if @localtime
  end

  describe '#format' do
    it 'works with msg' do
      expect(subject.format(msg: 'msg')).to eq(slack: {}, msg: '01 00:00:00 msg')
    end

    it 'works with slack' do
      expect(subject.format(slack: { channel: :channel })).to eq(slack: { channel: :channel }, msg: '01 00:00:00 ')
    end

    it 'works with timestamp' do
      expect(subject.format(ts: 1234.0)).to eq(slack: {}, msg: '01 00:20:34 ')
    end
  end

  describe '#log_impl' do
    it 'calls #write and #format' do
      expect_any_instance_of(Slack::Notifier).to receive(:ping).with(/ msg$/).once
      subject.log_impl(slack: { channel: :channel }, msg: 'msg')
    end
  end
end
