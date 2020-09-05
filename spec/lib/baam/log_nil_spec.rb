# frozen_string_literal: true

RSpec.describe Baam::LogNil do
  let(:msg) { 'msg' }
  it 'works' do
    expect(subject).to receive(:log_impl).with(msg)
    subject.log(msg)
  end
end
