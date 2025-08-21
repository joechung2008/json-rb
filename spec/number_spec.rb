# frozen_string_literal: true

require_relative '../lib/json'

RSpec.describe 'JSONParser::Number' do
  it 'parses an integer' do
    result = JSONParser.parse('42')
    expect(result[:token][:type]).to eq(JSONParser::Type::NUMBER)
  end

  it 'parses an integer value' do
    result = JSONParser.parse('42')
    expect(result[:token][:value]).to eq(42)
  end

  it 'parses a negative integer' do
    result = JSONParser.parse('-7')
    expect(result[:token][:value]).to eq(-7)
  end

  it 'parses a decimal number' do
    result = JSONParser.parse('3.14')
    expect(result[:token][:value]).to eq(3.14)
  end

  it 'parses a negative decimal' do
    result = JSONParser.parse('-2.71')
    expect(result[:token][:value]).to eq(-2.71)
  end

  it 'parses scientific notation' do
    result = JSONParser.parse('6.02e23')
    expect(result[:token][:value]).to eq(6.02e23)
  end

  it 'parses negative EXPONENT' do
    result = JSONParser.parse('1.23e-4')
    expect(result[:token][:value]).to eq(1.23e-4)
  end

  it 'raises error on incomplete number' do
    expect { JSONParser.parse('-') }.to raise_error(SyntaxError)
  end

  it 'raises error on invalid number' do
    expect { JSONParser.parse('abc') }.to raise_error(SyntaxError)
  end
end
