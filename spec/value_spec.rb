# frozen_string_literal: true

require_relative '../lib/json'

RSpec.describe 'JSON.parse value' do
  it 'parses a JSON array' do
    result = JSON.parse('[1,2,3]')
    expect(result[:token][:type]).to eq(JSON::Type::Array)
    expect(result[:token][:value].map { |v| v[:value] }).to eq([1, 2, 3])
  end

  it 'parses a JSON object' do
    result = JSON.parse('{"a":1}')
    expect(result[:token][:type]).to eq(JSON::Type::Object)
    key_token = result[:token][:members].first[:key]
    expect(key_token[:type]).to eq(JSON::Type::String)
    expect(key_token[:value]).to eq('a')
    expect(result[:token][:members].first[:value][:value]).to eq(1)
  end

  it 'parses a JSON string' do
    result = JSON.parse('"hello"')
    expect(result[:token][:type]).to eq(JSON::Type::String)
    expect(result[:token][:value]).to eq('hello')
  end

  it 'parses a JSON number' do
    result = JSON.parse('42')
    expect(result[:token][:type]).to eq(JSON::Type::Number)
    expect(result[:token][:value]).to eq(42)
  end

  it 'parses true' do
    result = JSON.parse('true')
    expect(result[:token][:type]).to eq(JSON::Type::True)
    expect(result[:token][:value]).to eq(true)
  end

  it 'parses false' do
    result = JSON.parse('false')
    expect(result[:token][:type]).to eq(JSON::Type::False)
    expect(result[:token][:value]).to eq(false)
  end

  it 'parses null' do
    result = JSON.parse('null')
    expect(result[:token][:type]).to eq(JSON::Type::Null)
    expect(result[:token][:value]).to eq(nil)
  end

  it 'raises error on invalid input' do
    expect { JSON.parse('invalid') }.to raise_error(SyntaxError)
  end
end
