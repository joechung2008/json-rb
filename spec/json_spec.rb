# frozen_string_literal: true

require_relative '../lib/json_rb'

RSpec.describe 'JSONParser' do
  describe '.parse' do
    it 'raises error on invalid input' do
      expect { JSONParser.parse('invalid') }.to raise_error(SyntaxError)
    end
  end
end
