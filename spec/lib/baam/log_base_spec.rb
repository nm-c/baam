# frozen_string_literal: true

RSpec.describe Baam::LogBase do
  let(:msg) { 'msg' }

  describe '#log' do
    it 'calls log_impl' do
      expect(subject).to receive(:log_impl).with(msg)
      subject.log(msg)
    end

    it 'is not implemented' do
      expect do
        subject.log(msg)
      end.to raise_error(NotImplementedError)
    end
  end
end
