@ruby -x "%~f0" %*
@exit /b %ERRORLEVEL%

#!/usr/bin/env ruby

require_relative '../lib/json_rb'

expression = STDIN.read

_, token = JSONParser.parse(expression).values_at(:skip, :token)
puts token
