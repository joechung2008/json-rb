# frozen_string_literal: true

require_relative '../lib/json'

RSpec.describe 'JSON::Value' do
  it 'parses a JSON array and checks type' do
    result = JSON.parse('[1,2,3]')
    expect(result[:token][:type]).to eq(JSON::Type::ARRAY)
  end

  it 'parses a JSON array and checks values' do
    result = JSON.parse('[1,2,3]')
    expect(result[:token][:value].map { |v| v[:value] }).to eq([1, 2, 3])
  end

  it 'parses a JSON object and checks type' do
    result = JSON.parse('{"a":1}')
    expect(result[:token][:type]).to eq(JSON::Type::OBJECT)
  end

  it 'parses a JSON object and checks key type' do
    result = JSON.parse('{"a":1}')
    key_token = result[:token][:members].first[:key]
    expect(key_token[:type]).to eq(JSON::Type::STRING)
  end

  it 'parses a JSON object and checks key value' do
    result = JSON.parse('{"a":1}')
    key_token = result[:token][:members].first[:key]
    expect(key_token[:value]).to eq('a')
  end

  it 'parses a JSON object and checks member value' do
    result = JSON.parse('{"a":1}')
    expect(result[:token][:members].first[:value][:value]).to eq(1)
  end

  it 'parses a JSON string and checks type' do
    result = JSON.parse('"hello"')
    expect(result[:token][:type]).to eq(JSON::Type::STRING)
  end

  it 'parses a JSON string and checks value' do
    result = JSON.parse('"hello"')
    expect(result[:token][:value]).to eq('hello')
  end

  it 'parses a JSON number and checks type' do
    result = JSON.parse('42')
    expect(result[:token][:type]).to eq(JSON::Type::NUMBER)
  end

  it 'parses a JSON number and checks value' do
    result = JSON.parse('42')
    expect(result[:token][:value]).to eq(42)
  end

  it 'parses true and checks type' do
    result = JSON.parse('true')
    expect(result[:token][:type]).to eq(JSON::Type::TRUE)
  end

  it 'parses true and checks value' do
    result = JSON.parse('true')
    expect(result[:token][:value]).to be true
  end

  it 'parses false and checks type' do
    result = JSON.parse('false')
    expect(result[:token][:type]).to eq(JSON::Type::FALSE)
  end

  it 'parses false and checks value' do
    result = JSON.parse('false')
    expect(result[:token][:value]).to be false
  end

  it 'parses null and checks type' do
    result = JSON.parse('null')
    expect(result[:token][:type]).to eq(JSON::Type::NULL)
  end

  it 'parses null and checks value' do
    result = JSON.parse('null')
    expect(result[:token][:value]).to be_nil
  end

  it 'raises error on invalid input' do
    expect { JSON.parse('invalid') }.to raise_error(SyntaxError)
  end
end
