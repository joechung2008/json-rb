# frozen_string_literal: true

require_relative '../lib/json'

RSpec.describe 'JSON.parse string' do
  it 'parses a simple string' do
    result = JSON.parse('"hello"')
    expect(result[:token][:type]).to eq(JSON::Type::String)
    expect(result[:token][:value]).to eq('hello')
  end

  it 'parses a string with escaped quotes' do
    result = JSON.parse('"he\\"llo"')
    expect(result[:token][:value]).to eq('he"llo')
  end

  it 'parses a string with escaped backslash' do
    result = JSON.parse('"he\\\\llo"')
    expect(result[:token][:value]).to eq('he\\llo')
  end

  it 'parses a string with escaped slash' do
    result = JSON.parse('"he\\/llo"')
    expect(result[:token][:value]).to eq('he/llo')
  end

  it 'raises error on missing opening quote' do
    expect { JSON.parse('hello"') }.to raise_error(SyntaxError)
  end
end
