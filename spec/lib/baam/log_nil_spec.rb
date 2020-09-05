# frozen_string_literal: true

RSpec.describe Baam::LogNil do
  let(:msg) { 'msg' }
  it '#log' do
    subject.log(msg)
  end
end
