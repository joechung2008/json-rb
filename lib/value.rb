require_relative "array"
require_relative "number"
require_relative "object"
require_relative "string"
require_relative "type"

module JSON
  module Value
    module Mode
      SCANNING = 0
      ARRAY = 1
      FALSE = 2
      NULL = 3
      NUMBER = 4
      OBJECT = 5
      STRING = 6
      TRUE = 7
      STOP = 8
    end

    def parse(value, delimiters = nil)
      mode = Mode::SCANNING
      pos = 0

      while pos < value.length and mode != Mode::STOP
        ch = value[pos]

        case mode
        when Mode::SCANNING
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "["
            mode = Mode::ARRAY
          elsif ch == "f"
            mode = Mode::FALSE
          elsif ch == "n"
            mode = Mode::NULL
          elsif /[-\d]/.match?(ch)
            mode = Mode::NUMBER
          elsif ch == "{"
            mode = Mode::OBJECT
          elsif ch == '"'
            mode = Mode::STRING
          elsif ch == "t"
            mode = Mode::TRUE
          elsif !delimiters.nil? and delimiters.match(ch)
            mode = Mode::STOP
          else
            raise SyntaxError, "unexpected character '#{ch}'"
          end
        when Mode::ARRAY
          slice = value[pos..-1]
          skip, token = JSON::Array.parse(slice).values_at(:skip, :token)
          pos += skip
          mode = Mode::STOP
        when Mode::FALSE
          slice = value[pos..-1]
          if /^false/i.match?(slice)
            token = { type: JSON::Type::FALSE, value: false }
            pos += 5
            mode = Mode::STOP
          else
            raise SyntaxError, "expected 'false', actual '#{slice}'"
          end
        when Mode::NULL
          slice = value[pos..-1]
          if /^null/i.match?(slice)
            token = { type: JSON::Type::NULL, value: nil }
            pos += 4
            mode = Mode::STOP
          else
            raise SyntaxError, "expected 'null', actual '#{slice}'"
          end
        when Mode::NUMBER
          slice = value[pos..-1]
          skip, token = JSON::Number.parse(slice, delimiters.nil? ? /\s/ : delimiters).values_at(:skip, :token)
          pos += skip
          mode = Mode::STOP
        when Mode::OBJECT
          slice = value[pos..-1]
          skip, token = JSON::Object.parse(slice).values_at(:skip, :token)
          pos += skip
          mode = Mode::STOP
        when Mode::STRING
          slice = value[pos..-1]
          skip, token = JSON::String.parse(slice).values_at(:skip, :token)
          pos += skip
          mode = Mode::STOP
        when Mode::TRUE
          slice = value[pos..-1]
          if /^true/i.match?(slice)
            token = { type: JSON::Type::TRUE, value: true }
            pos += 4
            mode = Mode::STOP
          else
            raise SyntaxError, "expected 'true', actual '#{slice}'"
          end
        when Mode::STOP
          # do nothing, we are done
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
