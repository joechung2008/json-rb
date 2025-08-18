require_relative "value"

module JSON
  module Mode
    Scanning = 0
    Value = 1
    End = 2
  end

  def parse(json)
    mode = Mode::Scanning
    pos = 0

    while pos < json.length and mode != Mode::End
      ch = json[pos]

      case mode
      when Mode::Scanning
        if /\s/.match?(ch)
          pos += 1
        else
          mode = Mode::Value
        end
      when Mode::Value
        slice = json[pos..-1]
        skip, token = JSON::Value.parse(slice).values_at(:skip, :token)
        pos += skip
        mode = Mode::End
      when Mode::End

      else
        raise SyntaxError, "unexpected mode #{mode}"
      end
    end

    { skip: pos, token: token }
  end

  module_function :parse
end
