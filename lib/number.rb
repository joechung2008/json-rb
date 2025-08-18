require_relative "type"

module JSON
  module Number
    module Mode
      Scanning = 0
      Characteristic = 1
      CharacteristicDigit = 2
      DecimalPoint = 3
      Mantissa = 4
      Exponent = 5
      ExponentSign = 6
      ExponentFirstDigit = 7
      ExponentDigits = 8
      End = 9
    end

    def parse(number, delimiters = nil)
      mode = Mode::Scanning
      pos = 0
      token = { type: JSON::Type::Number, value: nil, value_as_string: nil }

      while pos < number.length and mode != Mode::End
        ch = number[pos]

        case mode
        when Mode::Scanning
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "-"
            pos += 1
            token[:value_as_string] = "-"
            mode = Mode::Characteristic
          else
            token[:value_as_string] = ""
            mode = Mode::Characteristic
          end
        when Mode::Characteristic
          if ch == "0"
            pos += 1
            token[:value_as_string] += ch
            mode = Mode::DecimalPoint
          elsif /[1-9]/.match?(ch)
            pos += 1
            token[:value_as_string] += ch
            mode = Mode::CharacteristicDigit
          else
            raise SyntaxError, "expected digit, actual '#{ch}'"
          end
        when Mode::CharacteristicDigit
          if /\d/.match?(ch)
            pos += 1
            token[:value_as_string] += ch
          elsif !delimiters.nil? and delimiters.match(ch)
            mode = Mode::End
          else
            mode = Mode::DecimalPoint
          end
        when Mode::DecimalPoint
          if ch == "."
            pos += 1
            token[:value_as_string] += ch
            mode = Mode::Mantissa
          elsif !delimiters.nil? and delimiters.match(ch)
            mode = Mode::End
          else
            mode = Mode::Exponent
          end
        when Mode::Mantissa
          if /\d/.match?(ch)
            pos += 1
            token[:value_as_string] += ch
          elsif /e/i.match?(ch)
            mode = Mode::Exponent
          elsif !delimiters.nil? and delimiters.match(ch)
            mode = Mode::End
          else
            raise SyntaxError, "unexpected character '#{ch}'"
          end
        when Mode::Exponent
          if /e/i.match?(ch)
            pos += 1
            token[:value_as_string] += "e"
            mode = Mode::ExponentSign
          else
            raise SyntaxError, "expected 'e' or 'E', actual '#{ch}'"
          end
        when Mode::ExponentSign
          if ch == "+" or ch == "-"
            pos += 1
            token[:value_as_string] += ch
          end
          mode = Mode::ExponentFirstDigit
        when Mode::ExponentFirstDigit
          if /\d/.match?(ch)
            pos += 1
            token[:value_as_string] += ch
            mode = Mode::ExponentDigits
          else
            raise SyntaxError, "expected digit, actual '#{ch}'"
          end
        when Mode::ExponentDigits
          if /\d/.match?(ch)
            pos += 1
            token[:value_as_string] += ch
          elsif !delimiters.nil? and delimiters.match(ch)
            mode = Mode::End
          else
            raise SyntaxError, "expected digit, actual '#{ch}'"
          end
        when Mode::End

        else
          raise SyntaxError, "unexpected mode #{mode}"
        end
      end

      if mode == Mode::Characteristic or mode == Mode::ExponentFirstDigit
        raise SyntaxError, "incomplete expression, mode #{mode}"
      else
        token[:value] = Float(token[:value_as_string])
      end

      { skip: pos, token: token }
    end

    module_function :parse
  end
end
