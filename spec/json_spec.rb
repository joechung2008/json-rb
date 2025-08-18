# frozen_string_literal: true

require_relative '../lib/json'

RSpec.describe JSON do
  describe '.parse' do
    it 'raises error on invalid input' do
      expect { JSON.parse('invalid') }.to raise_error(SyntaxError)
    end
  end
end
