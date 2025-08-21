# frozen_string_literal: true

require_relative '../lib/json'

RSpec.describe 'JSON::Number' do
  it 'parses an integer' do
    result = JSON.parse('42')
    expect(result[:token][:type]).to eq(JSON::Type::NUMBER)
  end

  it 'parses an integer value' do
    result = JSON.parse('42')
    expect(result[:token][:value]).to eq(42)
  end

  it 'parses a negative integer' do
    result = JSON.parse('-7')
    expect(result[:token][:value]).to eq(-7)
  end

  it 'parses a decimal number' do
    result = JSON.parse('3.14')
    expect(result[:token][:value]).to eq(3.14)
  end

  it 'parses a negative decimal' do
    result = JSON.parse('-2.71')
    expect(result[:token][:value]).to eq(-2.71)
  end

  it 'parses scientific notation' do
    result = JSON.parse('6.02e23')
    expect(result[:token][:value]).to eq(6.02e23)
  end

  it 'parses negative EXPONENT' do
    result = JSON.parse('1.23e-4')
    expect(result[:token][:value]).to eq(1.23e-4)
  end

  it 'raises error on incomplete number' do
    expect { JSON.parse('-') }.to raise_error(SyntaxError)
  end

  it 'raises error on invalid number' do
    expect { JSON.parse('abc') }.to raise_error(SyntaxError)
  end
end
