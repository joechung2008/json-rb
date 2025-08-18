require_relative "type"
require_relative "value"

module JSON
  module Array
    module Mode
      Scanning = 0
      Elements = 1
      Delimiter = 2
      End = 3
    end

    def parse(array)
      mode = Mode::Scanning
      pos = 0
      token = { type: JSON::Type::Array, value: [] }

      while pos < array.length and mode != Mode::End
        ch = array[pos]

        case mode
        when Mode::Scanning
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "["
            pos += 1
            mode = Mode::Elements
          else
            raise SyntaxError, "expected '[', actual '#{ch}'"
          end
        when Mode::Elements
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "]"
            raise SyntaxError, "unexpected ','" if token[:value].length > 0

            pos += 1
            mode = Mode::End
          else
            slice = array[pos..-1]
            skip, value = JSON::Value.parse(slice, /[,\]\s]/).values_at(:skip, :token)
            token[:value].push(value)
            pos += skip
            mode = Mode::Delimiter
          end
        when Mode::Delimiter
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "]"
            pos += 1
            mode = Mode::End
          elsif ch == ","
            pos += 1
            mode = Mode::Elements
          else
            raise SyntaxError, "expected ',' or ']', actual '#{ch}'"
          end
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
