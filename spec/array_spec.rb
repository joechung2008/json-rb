# frozen_string_literal: true

require_relative '../lib/json'

RSpec.describe 'JSON.parse array' do
  it 'parses an empty array' do
    result = JSON.parse('[]')
    expect(result[:token][:type]).to eq(JSON::Type::Array)
    expect(result[:token][:value]).to eq([])
  end

  it 'parses an array of numbers' do
    result = JSON.parse('[1,2,3]')
    expect(result[:token][:value].map { |v| v[:value] }).to eq([1, 2, 3])
  end

  it 'parses an array of mixed types' do
    result = JSON.parse('[1,"a",true,null]')
    expect(result[:token][:value].map { |v| v[:value] }).to eq([1, 'a', true, nil])
  end

  it 'parses a nested array' do
    result = JSON.parse('[[1,2],3]')
    nested = result[:token][:value][0]
    expect(nested[:type]).to eq(JSON::Type::Array)
    expect(nested[:value].map { |v| v[:value] }).to eq([1, 2])
    expect(result[:token][:value][1][:value]).to eq(3)
  end

  it 'raises error on missing opening bracket' do
    expect { JSON.parse('1,2,3]') }.to raise_error(SyntaxError)
  end

  it 'raises error on unexpected delimiter' do
    expect { JSON.parse('[1,2,3,]') }.to raise_error(SyntaxError)
  end
end
