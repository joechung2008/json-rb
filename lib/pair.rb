require_relative "string"
require_relative "type"
require_relative "value"

module JSON
  module Pair
    module Mode
      SCANNING = 0
      KEY = 1
      COLON = 2
      VALUE = 3
      STOP = 4
    end

    def parse(pair, delimiters = nil)
      mode = Mode::SCANNING
      pos = 0
      token = { type: JSON::Type::PAIR, key: nil, value: nil }

      while pos < pair.length and mode != Mode::STOP
        ch = pair[pos]

        case mode
        when Mode::SCANNING
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          else
            mode = Mode::KEY
          end
        when Mode::KEY
          slice = pair[pos..-1]
          skip, key = JSON::String.parse(slice).values_at(:skip, :token)
          token[:key] = key
          pos += skip
          mode = Mode::COLON
        when Mode::COLON
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == ":"
            pos += 1
            mode = Mode::VALUE
          else
            raise SyntaxError, "expected ':', actual '#{ch}'"
          end
        when Mode::VALUE
          slice = pair[pos..-1]
          skip, value = JSON::Value.parse(slice, delimiters).values_at(:skip, :token)
          token[:value] = value
          pos += skip
          mode = Mode::STOP
        when Mode::STOP
          # Do nothing, we are done parsing
        else
          raise SyntaxError, "unexpected mode #{mode}"
        end
      end

      { skip: pos, token: token }
    end

    module_function :parse
  end
end
