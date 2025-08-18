require_relative "string"
require_relative "type"
require_relative "value"

module JSON
  module Pair
    module Mode
      Scanning = 0
      Key = 1
      Colon = 2
      Value = 3
      End = 4
    end

    def parse(pair, delimiters = nil)
      mode = Mode::Scanning
      pos = 0
      token = { type: JSON::Type::Pair, key: nil, value: nil }

      while pos < pair.length and mode != Mode::End
        ch = pair[pos]

        case mode
        when Mode::Scanning
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          else
            mode = Mode::Key
          end
        when Mode::Key
          slice = pair[pos..-1]
          skip, key = JSON::String.parse(slice).values_at(:skip, :token)
          token[:key] = key
          pos += skip
          mode = Mode::Colon
        when Mode::Colon
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == ":"
            pos += 1
            mode = Mode::Value
          else
            raise SyntaxError, "expected ':', actual '#{ch}'"
          end
        when Mode::Value
          slice = pair[pos..-1]
          skip, value = JSON::Value.parse(slice, delimiters).values_at(:skip, :token)
          token[:value] = value
          pos += skip
          mode = Mode::End
        when Mode::End

        else
          raise SyntaxError, "unexpected mode #{mode}"
        end
      end

      { skip: pos, token: token }
    end

    module_function :parse
  end
end
