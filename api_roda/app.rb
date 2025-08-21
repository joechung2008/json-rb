require_relative '../lib/json'
require 'json'
require 'roda'

class App < Roda
  plugin :json

  route do |r|
    r.on "api", "v1", "parse" do
      r.post do
        if r.env['CONTENT_TYPE'] == 'text/plain'
          begin
            parsed = JSONParser.parse(r.body.read)
            response.status = 200
            response['Content-Type'] = 'application/json'
            JSON.generate(parsed)
          rescue SyntaxError => e
            response.status = 400
            response['Content-Type'] = 'application/json'
            { code: 400, error: e.message }
          end
        else
          response.status = 415
          response['Content-Type'] = 'application/json'
          { code: 415, error: "Unsupported Media Type" }
        end
      end
    end
  end
end
