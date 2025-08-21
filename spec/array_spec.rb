# frozen_string_literal: true

require_relative '../lib/json'

RSpec.describe 'JSON::Array' do
  it 'parses an empty array and returns type Array' do
    result = JSON.parse('[]')
    expect(result[:token][:type]).to eq(JSON::Type::ARRAY)
  end

  it 'parses an empty array and returns an empty value' do
    result = JSON.parse('[]')
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

  it 'parses a nested array and checks type of first element' do
    result = JSON.parse('[[1,2],3]')
    nested = result[:token][:value][0]
    expect(nested[:type]).to eq(JSON::Type::ARRAY)
  end

  it 'parses a nested array and checks values of first element' do
    result = JSON.parse('[[1,2],3]')
    nested = result[:token][:value][0]
    expect(nested[:value].map { |v| v[:value] }).to eq([1, 2])
  end

  it 'parses a nested array and checks value of second element' do
    result = JSON.parse('[[1,2],3]')
    expect(result[:token][:value][1][:value]).to eq(3)
  end

  it 'raises error on missing opening bracket' do
    expect { JSON.parse('1,2,3]') }.to raise_error(SyntaxError)
  end

  it 'raises error on unexpected delimiter' do
    expect { JSON.parse('[1,2,3,]') }.to raise_error(SyntaxError)
  end
end
