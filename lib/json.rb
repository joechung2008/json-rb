require_relative "value"

module JSONParser
  module Mode
    SCANNING = 0
    VALUE = 1
    STOP = 2
  end

  def parse(json)
    mode = Mode::SCANNING
    pos = 0

    while pos < json.length and mode != Mode::STOP
      ch = json[pos]

      case mode
      when Mode::SCANNING
        if /\s/.match?(ch)
          pos += 1
        else
          mode = Mode::VALUE
        end
      when Mode::VALUE
        slice = json[pos..-1]
        skip, token = JSONParser::Value.parse(slice).values_at(:skip, :token)
        pos += skip
        mode = Mode::STOP
      when Mode::STOP
        # If we reach here, it means we have already parsed the value
      else
        raise SyntaxError, "unexpected mode #{mode}"
      end
    end

    { skip: pos, token: token }
  end

  module_function :parse
end
