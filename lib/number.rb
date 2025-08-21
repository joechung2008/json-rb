require_relative "type"

module JSON
  module Number
    module Mode
      SCANNING = 0
      CHARACTERISTIC = 1
      CHARACTERISTIC_DIGIT = 2
      DECIMAL_POINT = 3
      MANTISSA = 4
      EXPONENT = 5
      EXPONENT_SIGN = 6
      EXPONENT_FIRST_DIGIT = 7
      EXPONENT_DIGITS = 8
      STOP = 9
    end

    def parse(number, delimiters = nil)
      mode = Mode::SCANNING
      pos = 0
      token = { type: JSON::Type::NUMBER, value: nil, value_as_string: nil }

      while pos < number.length and mode != Mode::STOP
        ch = number[pos]

        case mode
        when Mode::SCANNING
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "-"
            pos += 1
            token[:value_as_string] = "-"
            mode = Mode::CHARACTERISTIC
          else
            token[:value_as_string] = ""
            mode = Mode::CHARACTERISTIC
          end
        when Mode::CHARACTERISTIC
          if ch == "0"
            pos += 1
            token[:value_as_string] += ch
            mode = Mode::DECIMAL_POINT
          elsif /[1-9]/.match?(ch)
            pos += 1
            token[:value_as_string] += ch
            mode = Mode::CHARACTERISTIC_DIGIT
          else
            raise SyntaxError, "expected digit, actual '#{ch}'"
          end
        when Mode::CHARACTERISTIC_DIGIT
          if /\d/.match?(ch)
            pos += 1
            token[:value_as_string] += ch
          elsif !delimiters.nil? and delimiters.match(ch)
            mode = Mode::STOP
          else
            mode = Mode::DECIMAL_POINT
          end
        when Mode::DECIMAL_POINT
          if ch == "."
            pos += 1
            token[:value_as_string] += ch
            mode = Mode::MANTISSA
          elsif !delimiters.nil? and delimiters.match(ch)
            mode = Mode::STOP
          else
            mode = Mode::EXPONENT
          end
        when Mode::MANTISSA
          if /\d/.match?(ch)
            pos += 1
            token[:value_as_string] += ch
          elsif /e/i.match?(ch)
            mode = Mode::EXPONENT
          elsif !delimiters.nil? and delimiters.match(ch)
            mode = Mode::STOP
          else
            raise SyntaxError, "unexpected character '#{ch}'"
          end
        when Mode::EXPONENT
          if /e/i.match?(ch)
            pos += 1
            token[:value_as_string] += "e"
            mode = Mode::EXPONENT_SIGN
          else
            raise SyntaxError, "expected 'e' or 'E', actual '#{ch}'"
          end
        when Mode::EXPONENT_SIGN
          if ch == "+" or ch == "-"
            pos += 1
            token[:value_as_string] += ch
          end
          mode = Mode::EXPONENT_FIRST_DIGIT
        when Mode::EXPONENT_FIRST_DIGIT
          if /\d/.match?(ch)
            pos += 1
            token[:value_as_string] += ch
            mode = Mode::EXPONENT_DIGITS
          else
            raise SyntaxError, "expected digit, actual '#{ch}'"
          end
        when Mode::EXPONENT_DIGITS
          if /\d/.match?(ch)
            pos += 1
            token[:value_as_string] += ch
          elsif !delimiters.nil? and delimiters.match(ch)
            mode = Mode::STOP
          else
            raise SyntaxError, "expected digit, actual '#{ch}'"
          end
        when Mode::STOP
          # nothing to do, we are done
        else
          raise SyntaxError, "unexpected mode #{mode}"
        end
      end

      if mode == Mode::CHARACTERISTIC or mode == Mode::EXPONENT_FIRST_DIGIT
        raise SyntaxError, "incomplete expression, mode #{mode}"
      else
        token[:value] = Float(token[:value_as_string])
      end

      { skip: pos, token: token }
    end

    module_function :parse
  end
end
