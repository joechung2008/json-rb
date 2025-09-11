# frozen_string_literal: true

require_relative '../lib/json_rb'

RSpec.describe 'JSONParser::Value' do
  it 'parses a JSON array and checks type' do
    result = JSONParser.parse('[1,2,3]')
    expect(result[:token][:type]).to eq(JSONParser::Type::ARRAY)
  end

  it 'parses a JSON array and checks values' do
    result = JSONParser.parse('[1,2,3]')
    expect(result[:token][:value].map { |v| v[:value] }).to eq([1, 2, 3])
  end

  it 'parses a JSON object and checks type' do
    result = JSONParser.parse('{"a":1}')
    expect(result[:token][:type]).to eq(JSONParser::Type::OBJECT)
  end

  it 'parses a JSON object and checks key type' do
    result = JSONParser.parse('{"a":1}')
    key_token = result[:token][:members].first[:key]
    expect(key_token[:type]).to eq(JSONParser::Type::STRING)
  end

  it 'parses a JSON object and checks key value' do
    result = JSONParser.parse('{"a":1}')
    key_token = result[:token][:members].first[:key]
    expect(key_token[:value]).to eq('a')
  end

  it 'parses a JSON object and checks member value' do
    result = JSONParser.parse('{"a":1}')
    expect(result[:token][:members].first[:value][:value]).to eq(1)
  end

  it 'parses a JSON string and checks type' do
    result = JSONParser.parse('"hello"')
    expect(result[:token][:type]).to eq(JSONParser::Type::STRING)
  end

  it 'parses a JSON string and checks value' do
    result = JSONParser.parse('"hello"')
    expect(result[:token][:value]).to eq('hello')
  end

  it 'parses a JSON number and checks type' do
    result = JSONParser.parse('42')
    expect(result[:token][:type]).to eq(JSONParser::Type::NUMBER)
  end

  it 'parses a JSON number and checks value' do
    result = JSONParser.parse('42')
    expect(result[:token][:value]).to eq(42)
  end

  it 'parses true and checks type' do
    result = JSONParser.parse('true')
    expect(result[:token][:type]).to eq(JSONParser::Type::TRUE)
  end

  it 'parses true and checks value' do
    result = JSONParser.parse('true')
    expect(result[:token][:value]).to be true
  end

  it 'parses false and checks type' do
    result = JSONParser.parse('false')
    expect(result[:token][:type]).to eq(JSONParser::Type::FALSE)
  end

  it 'parses false and checks value' do
    result = JSONParser.parse('false')
    expect(result[:token][:value]).to be false
  end

  it 'parses null and checks type' do
    result = JSONParser.parse('null')
    expect(result[:token][:type]).to eq(JSONParser::Type::NULL)
  end

  it 'parses null and checks value' do
    result = JSONParser.parse('null')
    expect(result[:token][:value]).to be_nil
  end

  it 'raises error on invalid input' do
    expect { JSONParser.parse('invalid') }.to raise_error(SyntaxError)
  end

  it 'raises error on empty input' do
    expect { JSONParser.parse('') }.to raise_error(SyntaxError, 'JSON cannot be empty')
  end
end
