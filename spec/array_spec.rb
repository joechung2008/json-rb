# frozen_string_literal: true

require_relative '../lib/json_rb'

RSpec.describe 'JSONParser::Array' do
  it 'parses an empty array and returns type Array' do
    result = JSONParser.parse('[]')
    expect(result[:token][:type]).to eq(JSONParser::Type::ARRAY)
  end

  it 'parses an empty array and returns an empty value' do
    result = JSONParser.parse('[]')
    expect(result[:token][:value]).to eq([])
  end

  it 'parses an array of numbers' do
    result = JSONParser.parse('[1,2,3]')
    expect(result[:token][:value].map { |v| v[:value] }).to eq([1, 2, 3])
  end

  it 'parses an array of mixed types' do
    result = JSONParser.parse('[1,"a",true,null]')
    expect(result[:token][:value].map { |v| v[:value] }).to eq([1, 'a', true, nil])
  end

  it 'parses a nested array and checks type of first element' do
    result = JSONParser.parse('[[1,2],3]')
    nested = result[:token][:value][0]
    expect(nested[:type]).to eq(JSONParser::Type::ARRAY)
  end

  it 'parses a nested array and checks values of first element' do
    result = JSONParser.parse('[[1,2],3]')
    nested = result[:token][:value][0]
    expect(nested[:value].map { |v| v[:value] }).to eq([1, 2])
  end

  it 'parses a nested array and checks value of second element' do
    result = JSONParser.parse('[[1,2],3]')
    expect(result[:token][:value][1][:value]).to eq(3)
  end

  it 'raises error on missing opening bracket' do
    expect { JSONParser.parse('1,2,3]') }.to raise_error(SyntaxError)
  end

  it 'raises error on unexpected delimiter' do
    expect { JSONParser.parse('[1,2,3,]') }.to raise_error(SyntaxError)
  end
end
