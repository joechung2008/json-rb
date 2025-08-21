require_relative "type"
require_relative "value"

module JSON
  module Array
    module Mode
      SCANNING = 0
      ELEMENTS = 1
      DELIMITER = 2
      STOP = 3
    end

    def parse(array)
      mode = Mode::SCANNING
      pos = 0
      token = { type: JSON::Type::ARRAY, value: [] }

      while pos < array.length and mode != Mode::STOP
        ch = array[pos]

        case mode
        when Mode::SCANNING
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "["
            pos += 1
            mode = Mode::ELEMENTS
          else
            raise SyntaxError, "expected '[', actual '#{ch}'"
          end
        when Mode::ELEMENTS
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "]"
            raise SyntaxError, "unexpected ','" if token[:value].length > 0

            pos += 1
            mode = Mode::STOP
          else
            slice = array[pos..-1]
            skip, value = JSON::Value.parse(slice, /[,\]\s]/).values_at(:skip, :token)
            token[:value].push(value)
            pos += skip
            mode = Mode::DELIMITER
          end
        when Mode::DELIMITER
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "]"
            pos += 1
            mode = Mode::STOP
          elsif ch == ","
            pos += 1
            mode = Mode::ELEMENTS
          else
            raise SyntaxError, "expected ',' or ']', actual '#{ch}'"
          end
        when Mode::STOP
          # If we reach here, it means we have already parsed the array
        else
          raise SyntaxError, "unexpected mode #{mode}"
        end
      end

      { skip: pos, token: token }
    end

    module_function :parse
  end
end
