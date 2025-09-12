# frozen_string_literal: true

require_relative '../lib/json_rb'

RSpec.describe JSONParser do
  describe 'pair parsing within objects' do
    it 'returns PAIR type for simple string key-value pair' do
      result = described_class.parse('{"name": "John"}')
      pair = result[:token][:members].first
      expect(pair[:type]).to eq(JSONParser::Type::PAIR)
    end

    it 'parses string key from simple key-value pair' do
      result = described_class.parse('{"name": "John"}')
      pair = result[:token][:members].first
      expect(pair[:key][:value]).to eq('name')
    end

    it 'parses string value from simple key-value pair' do
      result = described_class.parse('{"name": "John"}')
      pair = result[:token][:members].first
      expect(pair[:value][:value]).to eq('John')
    end

    it 'parses key from pair with number value' do
      result = described_class.parse('{"age": 42}')
      pair = result[:token][:members].first
      expect(pair[:key][:value]).to eq('age')
    end

    it 'parses number value from pair' do
      result = described_class.parse('{"age": 42}')
      pair = result[:token][:members].first
      expect(pair[:value][:value]).to eq(42)
    end

    it 'parses key from pair with boolean value' do
      result = described_class.parse('{"active": true}')
      pair = result[:token][:members].first
      expect(pair[:key][:value]).to eq('active')
    end

    it 'parses boolean value from pair' do
      result = described_class.parse('{"active": true}')
      pair = result[:token][:members].first
      expect(pair[:value][:value]).to be(true)
    end

    it 'parses key from pair with null value' do
      result = described_class.parse('{"data": null}')
      pair = result[:token][:members].first
      expect(pair[:key][:value]).to eq('data')
    end

    it 'parses null value from pair' do
      result = described_class.parse('{"data": null}')
      pair = result[:token][:members].first
      expect(pair[:value][:value]).to be_nil
    end

    it 'parses key from pair with array value' do
      result = described_class.parse('{"items": [1, 2, 3]}')
      pair = result[:token][:members].first
      expect(pair[:key][:value]).to eq('items')
    end

    it 'parses array value type from pair' do
      result = described_class.parse('{"items": [1, 2, 3]}')
      pair = result[:token][:members].first
      expect(pair[:value][:type]).to eq(JSONParser::Type::ARRAY)
    end

    it 'parses key from pair with object value' do
      result = described_class.parse('{"nested": {"inner": "value"}}')
      pair = result[:token][:members].first
      expect(pair[:key][:value]).to eq('nested')
    end

    it 'parses object value type from pair' do
      result = described_class.parse('{"nested": {"inner": "value"}}')
      pair = result[:token][:members].first
      expect(pair[:value][:type]).to eq(JSONParser::Type::OBJECT)
    end

    it 'parses key with whitespace around colon' do
      result = described_class.parse('{"key"  :  "value"}')
      pair = result[:token][:members].first
      expect(pair[:key][:value]).to eq('key')
    end

    it 'parses value with whitespace around colon' do
      result = described_class.parse('{"key"  :  "value"}')
      pair = result[:token][:members].first
      expect(pair[:value][:value]).to eq('value')
    end

    it 'parses key with leading and trailing whitespace' do
      result = described_class.parse('{  "key": "value"  }')
      pair = result[:token][:members].first
      expect(pair[:key][:value]).to eq('key')
    end

    it 'parses value with leading and trailing whitespace' do
      result = described_class.parse('{  "key": "value"  }')
      pair = result[:token][:members].first
      expect(pair[:value][:value]).to eq('value')
    end
  end

  context 'when encountering parse errors' do
    it 'raises error when colon is missing' do
      expect { described_class.parse('{"key" "value"}') }
        .to raise_error(SyntaxError, "expected ':', actual '\"'")
    end

    it 'raises error with invalid character instead of colon' do
      expect { described_class.parse('{"key"; "value"}') }
        .to raise_error(SyntaxError, "expected ':', actual ';'")
    end

    it 'raises error with malformed key' do
      expect { described_class.parse('{key": "value"}') }
        .to raise_error(SyntaxError, /expected '"'/)
    end

    it 'raises error with malformed value' do
      expect { described_class.parse('{"key": invalid}') }
        .to raise_error(SyntaxError, /unexpected character/)
    end
  end

  context 'when parsing multiple pairs' do
    it 'parses first key with comma delimiter' do
      result = described_class.parse('{"key1": "value1", "key2": "value2"}')
      first_pair = result[:token][:members].first
      expect(first_pair[:key][:value]).to eq('key1')
    end

    it 'parses first value with comma delimiter' do
      result = described_class.parse('{"key1": "value1", "key2": "value2"}')
      first_pair = result[:token][:members].first
      expect(first_pair[:value][:value]).to eq('value1')
    end

    it 'parses second key after comma delimiter' do
      result = described_class.parse('{"key1": "value1", "key2": "value2"}')
      second_pair = result[:token][:members][1]
      expect(second_pair[:key][:value]).to eq('key2')
    end

    it 'parses second value after comma delimiter' do
      result = described_class.parse('{"key1": "value1", "key2": "value2"}')
      second_pair = result[:token][:members][1]
      expect(second_pair[:value][:value]).to eq('value2')
    end

    it 'parses single pair without comma delimiter' do
      result = described_class.parse('{"key": "value"}')
      pair = result[:token][:members].first
      expect(pair[:key][:value]).to eq('key')
    end

    it 'parses single pair value without comma delimiter' do
      result = described_class.parse('{"key": "value"}')
      pair = result[:token][:members].first
      expect(pair[:value][:value]).to eq('value')
    end
  end
end
