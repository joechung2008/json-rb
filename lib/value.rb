require_relative "array"
require_relative "number"
require_relative "object"
require_relative "string"
require_relative "type"

module JSON
  module Value
    module Mode
      Scanning = 0
      Array = 1
      False = 2
      Null = 3
      Number = 4
      Object = 5
      String = 6
      True = 7
      End = 8
    end

    def parse(value, delimiters = nil)
      mode = Mode::Scanning
      pos = 0

      while pos < value.length and mode != Mode::End
        ch = value[pos]

        case mode
        when Mode::Scanning
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "["
            mode = Mode::Array
          elsif ch == "f"
            mode = Mode::False
          elsif ch == "n"
            mode = Mode::Null
          elsif /[-\d]/.match?(ch)
            mode = Mode::Number
          elsif ch == "{"
            mode = Mode::Object
          elsif ch == '"'
            mode = Mode::String
          elsif ch == "t"
            mode = Mode::True
          elsif !delimiters.nil? and delimiters.match(ch)
            mode = Mode::End
          else
            raise SyntaxError, "unexpected character '#{ch}'"
          end
        when Mode::Array
          slice = value[pos..-1]
          skip, token = JSON::Array.parse(slice).values_at(:skip, :token)
          pos += skip
          mode = Mode::End
        when Mode::False
          slice = value[pos..-1]
          if /^false/i.match?(slice)
            token = { type: JSON::Type::False, value: false }
            pos += 5
            mode = Mode::End
          else
            raise SyntaxError, "expected 'false', actual '#{slice}'"
          end
        when Mode::Null
          slice = value[pos..-1]
          if /^null/i.match?(slice)
            token = { type: JSON::Type::Null, value: nil }
            pos += 4
            mode = Mode::End
          else
            raise SyntaxError, "expected 'null', actual '#{slice}'"
          end
        when Mode::Number
          slice = value[pos..-1]
          skip, token = JSON::Number.parse(slice, delimiters.nil? ? /\s/ : delimiters).values_at(:skip, :token)
          pos += skip
          mode = Mode::End
        when Mode::Object
          slice = value[pos..-1]
          skip, token = JSON::Object.parse(slice).values_at(:skip, :token)
          pos += skip
          mode = Mode::End
        when Mode::String
          slice = value[pos..-1]
          skip, token = JSON::String.parse(slice).values_at(:skip, :token)
          pos += skip
          mode = Mode::End
        when Mode::True
          slice = value[pos..-1]
          if /^true/i.match?(slice)
            token = { type: JSON::Type::True, value: true }
            pos += 4
            mode = Mode::End
          else
            raise SyntaxError, "expected 'true', actual '#{slice}'"
          end
        when Mode::End

        else
          raise SyntaxError, "unexpected mode #{mode}"
        end
      end

      raise SyntaxError, "value cannot be empty" if token.nil?

      { skip: pos, token: token }
    end

    module_function :parse
  end
end
