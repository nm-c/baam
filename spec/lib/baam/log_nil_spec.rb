# frozen_string_literal: true

RSpec.describe Baam::LogNil do
  let(:data) { { msg: 'msg' } }
  it '#log' do
    subject.log(data)
  end
end
