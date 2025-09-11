# frozen_string_literal: true

require_relative '../lib/json_rb'

RSpec.describe 'JSONParser::String' do
  it 'parses a simple string' do
    result = JSONParser.parse('"hello"')
    expect(result[:token][:type]).to eq(JSONParser::Type::STRING)
  end

  it 'parses a simple string value' do
    result = JSONParser.parse('"hello"')
    expect(result[:token][:value]).to eq('hello')
  end

  it 'parses a string with escaped quotes' do
    result = JSONParser.parse('"he\\"llo"')
    expect(result[:token][:value]).to eq('he"llo')
  end

  it 'parses a string with escaped backslash' do
    result = JSONParser.parse('"he\\\\llo"')
    expect(result[:token][:value]).to eq('he\\llo')
  end

  it 'parses a string with escaped slash' do
    result = JSONParser.parse('"he\\/llo"')
    expect(result[:token][:value]).to eq('he/llo')
  end

  it 'raises error on missing opening quote' do
    expect { JSONParser.parse('hello"') }.to raise_error(SyntaxError)
  end
end
