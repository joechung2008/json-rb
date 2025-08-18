require_relative "type"

module JSON
  module String
    module Mode
      Scanning = 0
      Char = 1
      EscapedChar = 2
      Unicode = 3
      End = 4
    end

    def parse(string)
      mode = Mode::Scanning
      pos = 0
      token = { type: JSON::Type::String, value: nil }

      while pos < string.length and mode != Mode::End
        ch = string[pos]

        case mode
        when Mode::Scanning
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == '"'
            token[:value] = ""
            pos += 1
            mode = Mode::Char
          else
            raise SyntaxError, "expected '\"', actual '#{ch}'"
          end
        when Mode::Char
          if ch == "\\"
            pos += 1
            mode = Mode::EscapedChar
          elsif ch == '"'
            pos += 1
            mode = Mode::End
          elsif ch != '\n' and ch != '\r'
            token[:value] += ch
            pos += 1
          else
            raise SyntaxError, "unexpected character '#{ch}'"
          end
        when Mode::EscapedChar
          case ch
          when '"', "\\", "/"
            token[:value] += ch
            pos += 1
            mode = Mode::Char
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
            mode = Mode::Char
          when "u"
            pos += 1
            mode = Mode::Unicode
          else
            raise SyntaxError, "unexpected escape character '#{ch}'"
          end
        when Mode::Unicode
          slice = string[pos..pos + 4]
          begin
            hex = Integer("0x#{slice}")
          rescue ArgumentError
            raise SyntaxError, "unexpected Unicode code '#{slice}'"
          end
          token[:value] += hex.chr
          pos += 4
          mode = Mode::Char
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
