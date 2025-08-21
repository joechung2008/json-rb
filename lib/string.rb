require_relative "type"

module JSONParser
  module String
    module Mode
      SCANNING = 0
      CHAR = 1
      ESCAPED_CHAR = 2
      UNICODE = 3
      STOP = 4
    end

    def parse(string)
      mode = Mode::SCANNING
      pos = 0
      token = { type: JSONParser::Type::STRING, value: nil }

      while pos < string.length and mode != Mode::STOP
        ch = string[pos]

        case mode
        when Mode::SCANNING
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == '"'
            token[:value] = ""
            pos += 1
            mode = Mode::CHAR
          else
            raise SyntaxError, "expected '\"', actual '#{ch}'"
          end
        when Mode::CHAR
          if ch == "\\"
            pos += 1
            mode = Mode::ESCAPED_CHAR
          elsif ch == '"'
            pos += 1
            mode = Mode::STOP
          elsif ch != '\n' and ch != '\r'
            token[:value] += ch
            pos += 1
          else
            raise SyntaxError, "unexpected character '#{ch}'"
          end
        when Mode::ESCAPED_CHAR
          case ch
          when '"', "\\", "/"
            token[:value] += ch
            pos += 1
            mode = Mode::CHAR
          when "b", "f", "n", "r", "t"
            token[:value] +=
              case ch
              when "b" then '\b'
              when "f" then '\f'
              when "n" then '\n'
              when "r" then '\r'
              when "t" then '\t'
              end
            pos += 1
            mode = Mode::CHAR
          when "u"
            pos += 1
            mode = Mode::UNICODE
          else
            raise SyntaxError, "unexpected escape character '#{ch}'"
          end
        when Mode::UNICODE
          slice = string[pos..(pos + 4)]
          begin
            hex = Integer("0x#{slice}")
          rescue ArgumentError
            raise SyntaxError, "unexpected Unicode code '#{slice}'"
          end
          token[:value] += hex.chr
          pos += 4
          mode = Mode::Char
        when Mode::STOP
          # This should not happen, as we should have exited the loop
        else
          raise SyntaxError, "unexpected mode #{mode}"
        end
      end

      { skip: pos, token: token }
    end

    module_function :parse
  end
end
