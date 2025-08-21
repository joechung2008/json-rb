require_relative "pair"
require_relative "type"

module JSON
  module Object
    module Mode
      SCANNING = 0
      PAIR = 1
      DELIMITER = 2
      STOP = 3
    end

    def parse(object)
      mode = Mode::SCANNING
      pos = 0
      token = { type: JSON::Type::OBJECT, members: [] }

      while pos < object.length and mode != Mode::STOP
        ch = object[pos]

        case mode
        when Mode::SCANNING
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "{"
            pos += 1
            mode = Mode::PAIR
          else
            raise SyntaxError, "expected '{', actual '#{ch}'"
          end
        when Mode::PAIR
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == "}"
            if token[:members].length > 0
              raise SyntaxError, "unexpected ','"
            end

            pos += 1
            mode = Mode::STOP
          else
            slice = object[pos..-1]
            skip, pair = JSON::Pair.parse(slice, /[\s,\}]/).values_at(:skip, :token)
            token[:members].push(pair)
            pos += skip
            mode = Mode::DELIMITER
          end
        when Mode::DELIMITER
          if /[ \n\r\t]/.match?(ch)
            pos += 1
          elsif ch == ","
            pos += 1
            mode = Mode::PAIR
          elsif ch == "}"
            pos += 1
            mode = Mode::STOP
          else
            raise SyntaxError, "expected ',' or '}', actual '#{ch}'"
          end
        when Mode::STOP
          # do nothing, we are done
        else
          raise SyntaxError, "unexpected mode %{mode}"
        end
      end

      { skip: pos, token: token }
    end

    module_function :parse
  end
end
