require 'json'
require 'sinatra'

post '/api/v1/parse' do
  begin
    json_string = request.body.read
    parsed_json = JSON.parse(json_string)
    status 200
    content_type :json
    parsed_json.to_json
  rescue JSON::ParserError => e
    status 400
    content_type :json
    { code: 400, message: e.message }.to_json
  end
end
