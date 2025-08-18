require_relative "pair"
require_relative "type"

module JSON
  module Object
    module Mode
      Scanning = 0
      LeftBrace = 1
      Pair = 2
      Delimiter = 3
      End = 4
    end

    def parse(object)
      mode = Mode::Scanning
      pos = 0
      token = { type: JSON::Type::Object, members: [] }

      while pos < object.length and mode != Mode::End
        ch = object[pos]

        case mode
        when Mode::Scanning
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "{"
            pos += 1
            mode = Mode::Pair
          else
            raise SyntaxError, "expected '{', actual '#{ch}'"
          end
        when Mode::Pair
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "}"
            if token[:members].length > 0
              raise SyntaxError, "unexpected ','"
            end

            pos += 1
            mode = Mode::End
          else
            slice = object[pos..-1]
            skip, pair = JSON::Pair.parse(slice, /[\s,\}]/).values_at(:skip, :token)
            token[:members].push(pair)
            pos += skip
            mode = Mode::Delimiter
          end
        when Mode::Delimiter
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == ","
            pos += 1
            mode = Mode::Pair
          elsif ch == "}"
            pos += 1
            mode = Mode::End
          else
            raise SyntaxError, "expected ',' or '}', actual '#{ch}'"
          end
        when Mode::End

        else
          raise SyntaxError, "unexpected mode %{mode}"
        end
      end

      { skip: pos, token: token }
    end

    module_function :parse
  end
end
