# frozen_string_literal: true

require_relative '../lib/json_rb'

RSpec.describe 'JSONParser::Type' do
  describe 'type constants' do
    it 'defines UNKNOWN type' do
      expect(JSONParser::Type::UNKNOWN).to eq(0)
    end

    it 'defines ARRAY type' do
      expect(JSONParser::Type::ARRAY).to eq(1)
    end

    it 'defines FALSE type' do
      expect(JSONParser::Type::FALSE).to eq(2)
    end

    it 'defines NULL type' do
      expect(JSONParser::Type::NULL).to eq(3)
    end

    it 'defines NUMBER type' do
      expect(JSONParser::Type::NUMBER).to eq(4)
    end

    it 'defines OBJECT type' do
      expect(JSONParser::Type::OBJECT).to eq(5)
    end

    it 'defines PAIR type' do
      expect(JSONParser::Type::PAIR).to eq(6)
    end

    it 'defines STRING type' do
      expect(JSONParser::Type::STRING).to eq(7)
    end

    it 'defines TRUE type' do
      expect(JSONParser::Type::TRUE).to eq(8)
    end
  end

  describe 'type usage in parsing' do
    it 'returns ARRAY type for arrays' do
      result = JSONParser.parse('[]')
      expect(result[:token][:type]).to eq(JSONParser::Type::ARRAY)
    end

    it 'returns OBJECT type for objects' do
      result = JSONParser.parse('{}')
      expect(result[:token][:type]).to eq(JSONParser::Type::OBJECT)
    end

    it 'returns STRING type for strings' do
      result = JSONParser.parse('"hello"')
      expect(result[:token][:type]).to eq(JSONParser::Type::STRING)
    end

    it 'returns NUMBER type for numbers' do
      result = JSONParser.parse('42')
      expect(result[:token][:type]).to eq(JSONParser::Type::NUMBER)
    end

    it 'returns TRUE type for true' do
      result = JSONParser.parse('true')
      expect(result[:token][:type]).to eq(JSONParser::Type::TRUE)
    end

    it 'returns FALSE type for false' do
      result = JSONParser.parse('false')
      expect(result[:token][:type]).to eq(JSONParser::Type::FALSE)
    end

    it 'returns NULL type for null' do
      result = JSONParser.parse('null')
      expect(result[:token][:type]).to eq(JSONParser::Type::NULL)
    end

    it 'returns PAIR type for object pairs' do
      result = JSONParser.parse('{"key": "value"}')
      pairs = result[:token][:members]
      expect(pairs.first[:type]).to eq(JSONParser::Type::PAIR)
    end
  end

  describe 'type constants are unique' do
    it 'has UNKNOWN value at 0' do
      expect(JSONParser::Type::UNKNOWN).to eq(0)
    end

    it 'has ARRAY value at 1' do
      expect(JSONParser::Type::ARRAY).to eq(1)
    end

    it 'has FALSE value at 2' do
      expect(JSONParser::Type::FALSE).to eq(2)
    end

    it 'has NULL value at 3' do
      expect(JSONParser::Type::NULL).to eq(3)
    end

    it 'has NUMBER value at 4' do
      expect(JSONParser::Type::NUMBER).to eq(4)
    end

    it 'has OBJECT value at 5' do
      expect(JSONParser::Type::OBJECT).to eq(5)
    end

    it 'has PAIR value at 6' do
      expect(JSONParser::Type::PAIR).to eq(6)
    end

    it 'has STRING value at 7' do
      expect(JSONParser::Type::STRING).to eq(7)
    end

    it 'has TRUE value at 8' do
      expect(JSONParser::Type::TRUE).to eq(8)
    end
  end
end
