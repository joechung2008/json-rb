# frozen_string_literal: true

require_relative '../lib/json'

RSpec.describe 'JSON.parse object' do
  it 'parses an empty object' do
    result = JSON.parse('{}')
    expect(result[:token][:type]).to eq(JSON::Type::Object)
    expect(result[:token][:members]).to eq([])
  end

  it 'parses an object with one pair' do
    result = JSON.parse('{"a":1}')
    expect(result[:token][:members].length).to eq(1)
    pair = result[:token][:members].first
    key_token = pair[:key]
    expect(key_token[:type]).to eq(JSON::Type::String)
    expect(key_token[:value]).to eq('a')
    expect(pair[:value][:value]).to eq(1)
  end

  it 'parses an object with multiple pairs' do
    result = JSON.parse('{"a":1,"b":2}')
    expect(result[:token][:members].length).to eq(2)
    keys = result[:token][:members].map { |p| p[:key][:value] }
    expect(keys).to contain_exactly('a', 'b')
  end

  it 'raises error on unexpected delimiter' do
    expect { JSON.parse('{"a":1,}') }.to raise_error(SyntaxError)
  end
end
